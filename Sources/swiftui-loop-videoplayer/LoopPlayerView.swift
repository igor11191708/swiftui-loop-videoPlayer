//
//  PlayerView.swift
//
//
//  Created by Igor on 10.02.2023.
//

import SwiftUI
#if canImport(AVKit)
import AVKit
#endif

/// Player view for running a video in loop
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct LoopPlayerView: View {
    
    /// Set of settings for video the player
    public let settings: Settings
    
    private var videoId : String{
        [settings.name, settings.ext].joined(separator: ".")
    }
    
    // MARK: - Life cycle
    
    /// Player initializer
    /// - Parameters:
    ///   - fileName: Name of the video to play
    ///   - ext: Video extension
    ///   - gravity: A structure that defines how a layer displays a player’s visual content within the layer’s bounds
    ///   - eText: Error message text if file is not found
    ///   - eFontSize: Size of the error text
    public init(
        fileName: String,
        ext: String = "mp4",
        gravity: AVLayerVideoGravity = .resizeAspect,
        eColor: Color = .accentColor,
        eFontSize: CGFloat = 17.0
    ) {
        settings = Settings {
            FileName(fileName)
            Ext(ext)
            Gravity(gravity)
            ErrorGroup {
                EColor(eColor)
                EFontSize(eFontSize)
            }
        }
    }
    
    /// Player initializer in a declarative way
    /// - Parameter settings: Set of settings
    public init(_ settings: () -> Settings) {
        self.settings = settings()
    }
    
    // MARK: - API
    
    public var body: some View {
        #if os(iOS) || os(tvOS)
        LoopPlayerViewRepresentableIOS(settings: settings)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .id(videoId)
        #elseif os(macOS)
        LoopPlayerViewRepresentableMacOS(settings: settings)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .id(videoId)
        #endif
    }
}

// MARK: - Representable for iOS and tvOS

#if os(iOS) || os(tvOS)
@available(iOS 14.0, tvOS 14.0, *)
@MainActor
struct LoopPlayerViewRepresentableIOS: UIViewRepresentable {
    
    let settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func makeUIView(context: Context) -> UIView {
        createView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Remove all subviews and add the new one
        uiView.subviews.forEach { $0.removeFromSuperview() }
        let newView = createView()
        uiView.addSubview(newView)
        
        // Ensure the new view fits the bounds of the container view
        newView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
            newView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            newView.topAnchor.constraint(equalTo: uiView.topAnchor),
            newView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor)
        ])
        
        // Force layout update
        uiView.setNeedsLayout()
        uiView.layoutIfNeeded()
    }
    
    private func createView() -> UIView {
        let name = settings.name
        let ext = settings.ext
        let gravity = settings.gravity
        let color = settings.errorColor
        let fontSize = settings.errorFontSize
        
        guard settings.areUnique else {
            return errorTpliOS(.settingsNotUnique, color, fontSize)
        }
        
        guard let view = LoopingPlayerUIView(name, width: ext, gravity: gravity) else {
            return errorTpliOS(.fileNotFound(name), color, fontSize)
        }
        return view
    }
}

// MARK: - Helpers for iOS and tvOS

fileprivate class ErrorMsgTextViewIOS: UITextView {
    
    override var contentSize: CGSize {
        didSet {
            var top = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            top = max(0, top)
            contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        }
    }
}

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

#endif

// MARK: - Representable for macOS

#if os(macOS)
/// A view representable for macOS to display a looping video player.
@available(macOS 11.0, *)
struct LoopPlayerViewRepresentableMacOS: NSViewRepresentable {
    
    /// The settings for the video player.
    let settings: Settings
    
    /// Creates the NSView instance for the video player.
    /// - Parameter context: The context in which the view is created.
    /// - Returns: An NSView that displays the video player, or an error view if there is an issue.
    func makeNSView(context: Context) -> NSView {
        let name = settings.name
        let ext = settings.ext
        let gravity = settings.gravity
        let color = settings.errorColor
        let fontSize = settings.errorFontSize
        
        // Check if the settings are unique
        guard settings.areUnique else {
            return errorTplmacOS(.settingsNotUnique, color, fontSize)
        }
        
        // Create the looping player view or return an error view if the file is not found
        guard let view = LoopingPlayerNSView(name, width: ext, gravity: gravity) else {
            return errorTplmacOS(.fileNotFound(name), color, fontSize)
        }
        return view
    }
    
    /// Updates the NSView instance.
    /// - Parameters:
    ///   - nsView: The NSView instance to update.
    ///   - context: The context in which the update occurs.
    func updateNSView(_ nsView: NSView, context: Context) {
        // Update the view if necessary
    }
}

// MARK: - Helpers for macOS

/// A custom NSTextView for displaying error messages on macOS.
fileprivate class ErrorMsgTextViewMacOS: NSTextView {
    
    /// Overrides the intrinsic content size to allow flexible width and height.
    override var intrinsicContentSize: NSSize {
        return NSSize(width: NSView.noIntrinsicMetric, height: NSView.noIntrinsicMetric)
    }
    
    /// Called when the view is added to a superview. Sets up the constraints for the view.
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 10),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -10),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    /// Adjusts the layout to center the text vertically within the view.
    override func layout() {
        super.layout()
        
        guard let layoutManager = layoutManager, let textContainer = textContainer else {
            return
        }
        
        let textHeight = layoutManager.usedRect(for: textContainer).size.height
        let containerHeight = bounds.size.height
        let verticalInset = max(0, (containerHeight - textHeight) / 2)
        
        textContainerInset = NSSize(width: 0, height: verticalInset)
    }
}

/// Creates a custom error view for macOS displaying an error message.
/// - Parameters:
///   - error: The error object containing the error description.
///   - color: The color to be used for the error text.
///   - fontSize: The font size to be used for the error text.
/// - Returns: An `NSView` containing the error message text view centered with padding.
fileprivate func errorTplmacOS(_ error: VPErrors, _ color: Color, _ fontSize: CGFloat) -> NSView {
    let textView = ErrorMsgTextViewMacOS()
    textView.isEditable = false
    textView.isSelectable = false
    textView.drawsBackground = false
    textView.string = error.description
    textView.alignment = .center
    textView.font = NSFont.systemFont(ofSize: fontSize)
    textView.textColor = NSColor(color)
    
    let containerView = NSView()
    containerView.addSubview(textView)
    
    textView.translatesAutoresizingMaskIntoConstraints = false
    
    // Center textView in containerView with padding
    NSLayoutConstraint.activate([
        textView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        textView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        textView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 10),
        textView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -10)
    ])
    
    return containerView
}

#endif
