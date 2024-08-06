//
//  LoopPlayerViewIOS.swift
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
struct LoopPlayerViewIOS: UIViewRepresentable, LoopPlayerViewProtocol {
    
    /// Settings for the player view
    public let settings: Settings
    
    /// The video asset to be played.
    private let asset: AVURLAsset?
    
    /// State to store any error that occurs
    @State private var error: VPErrors?

    /// Initializes the player view with settings
    /// - Parameter settings: The settings to configure the player view
    init(settings: Settings) {
        self.settings = settings
        self.asset = assetForName(name: settings.name, ext: settings.ext)
        self._error = State(initialValue: detectError(settings: settings, asset: self.asset))
    }
    
    /// Creates the container view with the player view and error view if needed
    /// - Parameter context: The context for the view
    /// - Returns: A configured UIView
    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        
        if let asset{
            let player: LoopingPlayerUIView = createPlayerView(context: context, asset: asset)
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

    
    /// Creates the coordinator for handling player errors
    /// - Returns: A configured Coordinator
    func makeCoordinator() -> PlayerErrorCoordinator {
        PlayerErrorCoordinator($error)
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
fileprivate func activateFullScreenConstraints(for view: UIView, in containerView: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        view.topAnchor.constraint(equalTo: containerView.topAnchor),
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
}

#endif




