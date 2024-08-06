//
//  LoopPlayerViewMacOS.swift
//
//
//  Created by Igor  on 05.08.24.
//

import SwiftUI
#if canImport(AVKit)
import AVKit
#endif

#if os(macOS)
import AppKit

/// A view representable for macOS to display a looping video player.
@available(macOS 11.0, *)
@MainActor
struct LoopPlayerViewMacOS: NSViewRepresentable, LoopPlayerViewProtocol {
    
    /// Settings for the player view
    public let settings: Settings
    
    /// The video asset to be played.
    private let asset: AVURLAsset?
    
    /// State to store any error that occurs
    @State private var error: VPErrors?

    /// Initializes the video player with given settings.
    /// - Parameter settings: The settings for the video player.
    init(settings: Settings) {
        self.settings = settings
        self.asset = assetForName(name: settings.name, ext: settings.ext)
        self._error = State(initialValue: detectError(settings: settings, asset: self.asset))
    }
    
    func makeNSView(context: Context) -> NSView {
        let container = NSView()
        
        if let asset{
            let player: LoopingPlayerNSView = createPlayerView(context: context, asset: asset)
            container.addSubview(player)
            activateFullScreenConstraints(for: player, in: container)
        }
        
        if let error = error {
            let errorView = errorTplmacOS(error, settings.errorColor, settings.errorFontSize)
            container.addSubview(errorView)
            activateFullScreenConstraints(for: errorView, in: container)
        }
        
        return container
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        nsView.subviews.filter { $0 is ErrorMsgViewMacOS }.forEach { $0.removeFromSuperview() }
        
        if let error = error {
            let errorView = errorTplmacOS(error, settings.errorColor, settings.errorFontSize)
            nsView.addSubview(errorView)
            activateFullScreenConstraints(for: errorView, in: nsView)
        }
    }
    
    func makeCoordinator() -> PlayerErrorCoordinator {
        PlayerErrorCoordinator($error)
    }
}

fileprivate func activateFullScreenConstraints(for view: NSView, in containerView: NSView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        view.topAnchor.constraint(equalTo: containerView.topAnchor),
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
}
#endif
