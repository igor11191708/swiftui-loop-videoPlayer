//
//  LoopPlayerViewProtocol.swift
//
//
//  Created by Igor  on 06.08.24.
//

import AVFoundation
import SwiftUI

/// Protocol that defines the common functionalities and properties
/// for looping video players on different platforms.
@available(iOS 14, macOS 11, tvOS 14, *)
@MainActor
public protocol LoopPlayerViewProtocol {
    
    #if os(iOS) || os(tvOS)
    associatedtype View :UIView
    #elseif os(macOS)
    associatedtype View : NSView
    #else
    associatedtype View : CustomView
    #endif
    
    associatedtype ErrorView
    
    /// Settings for configuring the video player.
    var settings: Settings { get }
    
    /// Initializes the video player with specific settings.
    /// - Parameter settings: The settings to configure the player.
    init(settings: Settings)
    
}

@available(iOS 14, macOS 11, tvOS 14, *)
public extension LoopPlayerViewProtocol{
    
    /// Updates the view by removing existing error messages and displaying a new one if an error is present.
    /// - Parameters:
    ///   - view: The view that needs to be updated with potential error messages.
    ///   - error: The optional error that might need to be displayed.
    @MainActor
    func updateView(_ view: View, error: VPErrors?) {
        
        makeErrorView(view, error: error)
    }
    
    @MainActor
    func makeErrorView(_ view: View, error: VPErrors?){
        if let error = error {

            let errorView = errorTpl(error, settings.errorColor, settings.errorFontSize)
            

            view.addSubview(errorView)
            
            activateFullScreenConstraints(for: errorView, in: view)
        }
    }
    
}

#if os(iOS) || os(tvOS)
@available(iOS 14, tvOS 14, *)
public extension LoopPlayerViewProtocol where Self: UIViewRepresentable, Context == UIViewRepresentableContext<Self> {
    
    /// Creates a player view for looping video content.
    /// - Parameters:
    ///   - context: The UIViewRepresentable context providing environment data and coordinator.
    ///   - asset: The AVURLAsset to be used for video playback.
    /// - Returns: A PlayerView instance conforming to LoopingPlayerProtocol.
    @MainActor
    func createPlayerView<PlayerView: LoopingPlayerProtocol>(
        context: Context,
        asset: AVURLAsset) -> PlayerView {
        

        let player = PlayerView(asset: asset, gravity: settings.gravity)

        player.delegate = context.coordinator as? PlayerErrorDelegate
        return player
    }
}

#endif

#if os(macOS)
@available(macOS 11, *)
public extension LoopPlayerViewProtocol where Self: NSViewRepresentable, Context == NSViewRepresentableContext<Self> {
    
    /// Creates a player view for looping video content.
    /// - Parameters:
    ///   - context: The NSViewRepresentable context providing environment data and coordinator.
    ///   - asset: The AVURLAsset to be used for video playback.
    /// - Returns: A PlayerView instance conforming to LoopingPlayerProtocol.
    @MainActor
    func createPlayerView<PlayerView: LoopingPlayerProtocol>(
        context: Context,
        asset: AVURLAsset) -> PlayerView {
        
        let player = PlayerView(asset: asset, gravity: settings.gravity)

            player.delegate = context.coordinator as? PlayerErrorDelegate
        return player
    }
}
#endif


