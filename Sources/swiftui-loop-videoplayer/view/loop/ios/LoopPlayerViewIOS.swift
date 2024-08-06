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

import UIKit

@available(iOS 14.0, tvOS 14.0, *)
@MainActor
struct LoopPlayerViewIOS: UIViewRepresentable, LoopPlayerViewProtocol {
    
    typealias View = UIView
    
    typealias ErrorView = ErrorMsgViewIOS
    
    typealias PlayerView = LoopingPlayerUIView
    
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
    
    /// Creates a coordinator that handles error-related updates and interactions between the SwiftUI view and its underlying model.
    /// - Returns: An instance of PlayerErrorCoordinator that can be used to manage error states and communicate between the view and model.
    func makeCoordinator() -> PlayerErrorCoordinator {
        PlayerErrorCoordinator($error)
    }
}
#endif
