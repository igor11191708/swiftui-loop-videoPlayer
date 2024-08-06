//
//  LoopPlayerMultiPlatform.swift
//
//
//  Created by Igor  on 05.08.24.
//

import SwiftUI

#if canImport(AVKit)
import AVKit
#endif

#if os(iOS) || os(tvOS)
import UIKit
#endif

#if os(macOS)
import AppKit
#endif

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
@MainActor
struct LoopPlayerMultiPlatform: LoopPlayerViewProtocol {
    
    #if os(iOS) || os(tvOS)
    typealias View = UIView
    
    typealias ErrorView = ErrorMsgViewIOS
    
    typealias PlayerView = LoopingPlayerUIView
    #elseif os(macOS)
    typealias View = NSView
    
    typealias ErrorView = ErrorMsgViewMacOS
    
    typealias PlayerView = LoopingPlayerNSView
    #endif
    
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

    
    /// Creates a coordinator that handles error-related updates and interactions between the SwiftUI view and its underlying model.
    /// - Returns: An instance of PlayerErrorCoordinator that can be used to manage error states and communicate between the view and model.
    func makeCoordinator() -> PlayerErrorCoordinator {
        PlayerErrorCoordinator($error)
    }
}

#if os(iOS) || os(tvOS)
extension LoopPlayerMultiPlatform: UIViewRepresentable{
    /// Creates the container view with the player view and error view if needed
    /// - Parameter context: The context for the view
    /// - Returns: A configured UIView
    func makeUIView(context: Context) -> UIView {
       let container = UIView()
   
       if let player: PlayerView = makePlayerView(
            container,
            asset: asset){
           player.delegate = context.coordinator
       }
        
        makeErrorView(container, error: error)
        
        return container
    }
    
    /// Updates the container view, removing any existing error views and adding a new one if needed
    /// - Parameters:
    ///   - uiView: The UIView to update
    ///   - context: The context for the view
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.subviews.filter { $0 is ErrorView }.forEach { $0.removeFromSuperview() }
        
        updateView(uiView, error: error)
    }
}
#endif

#if os(macOS)
extension LoopPlayerMultiPlatform: NSViewRepresentable{
    /// Creates the NSView for the representable component. It initializes the view, configures it with a player if available, and adds an error view if necessary.
    /// - Parameter context: The context containing environment and state information used during view creation.
    /// - Returns: A fully configured NSView containing both the media player and potentially an error message display.
    func makeNSView(context: Context) -> NSView {
        let container = NSView()
    
        if let player: PlayerView = makePlayerView(
             container,
             asset: asset){
            player.delegate = context.coordinator
        }
         
         makeErrorView(container, error: error)
         
         return container
    }
    
    /// Updates the specified NSView during the view's lifecycle in response to state changes.
    /// - Parameters:
    ///   - nsView: The NSView that needs updating.
    ///   - context: The context containing environment and state information used during the view update.
    func updateNSView(_ nsView: NSView, context: Context) {
        nsView.subviews.filter { $0 is ErrorView }.forEach { $0.removeFromSuperview() }
        
        updateView(nsView, error: error)
    }
}
#endif
