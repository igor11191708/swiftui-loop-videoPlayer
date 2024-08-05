//
//  MultiPlatformLoopPlayerView.swift
//
//
//  Created by Igor  on 05.08.24.
//

import SwiftUI

#if canImport(AVKit)
import AVKit
#endif

#if os(iOS) || os(tvOS)
@available(iOS 14.0, tvOS 14.0, *)
@MainActor
struct LoopPlayerViewRepresentableIOS: UIViewRepresentable {
    
    /// Settings for the player view
    private let settings: Settings
    
    /// The video asset to be played.
    private let asset: AVURLAsset?
    
    /// State to store any error that occurs
    @State private var error: VPErrors?

    /// Initializes the player view with settings
    /// - Parameter settings: The settings to configure the player view
    init(settings: Settings) {
        let name = settings.name
        let e: VPErrors?
        
        self.asset = assetForName(name: name, ext: settings.ext)
        self.settings = settings
        
        if !settings.areUnique{
            e = .settingsNotUnique
        }else if asset == nil{
             e = .sourceNotFound(name)
        }else{
            e = nil
        }

        self._error = State(initialValue: e)
    }
    
    /// Creates the container view with the player view and error view if needed
    /// - Parameter context: The context for the view
    /// - Returns: A configured UIView
    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        
        if let player = createPlayerView(context: context){
            container.addSubview(player)
            activateFullScreenConstraints(for: player, in: container)
        }
        
        if let error = error {
            let errorView = errorTpliOS(error, settings.errorColor, settings.errorFontSize)
            container.addSubview(errorView)
            activateFullScreenConstraints(for: errorView, in: container)
        }
        
        return container
    }
    
    /// Updates the container view, removing any existing error views and adding a new one if needed
    /// - Parameters:
    ///   - uiView: The UIView to update
    ///   - context: The context for the view
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.subviews.filter { $0 is ErrorMsgTextViewIOS }.forEach { $0.removeFromSuperview() }
        
        if let error = error {
            let errorView = errorTpliOS(error, settings.errorColor, settings.errorFontSize)
            uiView.addSubview(errorView)
            activateFullScreenConstraints(for: errorView, in: uiView)
        }
    }
    
    /// Creates the player view
    /// - Parameter context: The context for the view
    /// - Returns: A configured LoopingPlayerUIView
    private func createPlayerView(context: Context) -> LoopingPlayerUIView?{
        
        guard let asset else{ return nil }
        
        let player = LoopingPlayerUIView(asset: asset, gravity: settings.gravity)
        player.delegate = context.coordinator
        return player
    }
    
    /// Creates the coordinator for handling player errors
    /// - Returns: A configured Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator($error)
    }
    
    @MainActor
    class Coordinator: NSObject, PlayerErrorDelegate {
        
        @Binding private var error: VPErrors?
       
        init(_ error: Binding<VPErrors?>) {
            self._error = error
        }
        
        deinit {
            #if DEBUG
            print("deinit Coordinator")
            #endif
        }
        
        /// Handles receiving an error and updates the error state in the parent view
        /// - Parameter error: The error received
        func didReceiveError(_ error: VPErrors) {
                self.error = error
        }
    }
}

// MARK: - Helpers for iOS and tvOS

fileprivate class ErrorMsgTextViewIOS: UITextView {
    
    /// Adjusts the top content inset to vertically center the text.
    override var contentSize: CGSize {
        didSet {
            var top = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            top = max(0, top)
            contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        }
    }
}

/// Creates an error message view for iOS with the specified error, color, and font size.
///
/// - Parameters:
///   - error: The error to display.
///   - color: The color of the error text.
///   - fontSize: The font size of the error text.
/// - Returns: A configured UIView displaying the error message.
@MainActor
fileprivate func errorTpliOS(_ error: VPErrors, _ color: Color, _ fontSize: CGFloat) -> UIView {
    let textView = ErrorMsgTextViewIOS()
    textView.backgroundColor = .clear
    textView.text = error.description
    textView.textAlignment = .center
    textView.font = UIFont.systemFont(ofSize: fontSize)
    textView.textColor = UIColor(color)
    return textView
}

/// Activates full-screen constraints for a view within a container view.
///
/// - Parameters:
///   - view: The view to be constrained.
///   - containerView: The container view to which the constraints are applied.
func activateFullScreenConstraints(for view: UIView, in containerView: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        view.topAnchor.constraint(equalTo: containerView.topAnchor),
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
}

#endif




