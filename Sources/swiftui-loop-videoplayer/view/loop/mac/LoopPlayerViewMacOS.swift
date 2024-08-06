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
    
    typealias View = NSView
    
    typealias ErrorView = ErrorMsgViewMacOS
    
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
            compose(container, player)
        }
        
        makeErrorView(container, error: error)
        
        return container
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        nsView.subviews.filter { $0 is ErrorView }.forEach { $0.removeFromSuperview() }
        
        updateView(nsView, error: error)
    }
    
    func makeCoordinator() -> PlayerErrorCoordinator {
        PlayerErrorCoordinator($error)
    }
}

#endif
