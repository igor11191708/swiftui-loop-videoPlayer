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
    
    /// Settings for configuring the video player.
    var settings: Settings { get }
    
    /// Initializes the video player with specific settings.
    /// - Parameter settings: The settings to configure the player.
    init(settings: Settings)
}

#if os(iOS) || os(tvOS)
@available(iOS 14, tvOS 14, *)
extension LoopPlayerViewProtocol where Self: UIViewRepresentable, Context == UIViewRepresentableContext<Self> {
    
    /// Creates a player view for looping video content.
    /// - Parameters:
    ///   - context: The UIViewRepresentable context providing environment data and coordinator.
    ///   - asset: The AVURLAsset to be used for video playback.
    /// - Returns: A PlayerView instance conforming to LoopingPlayerProtocol.
    func createPlayerView<PlayerView: LoopingPlayerProtocol>(
        context: Context,
        asset: AVURLAsset) -> PlayerView {
        

        let player = PlayerView(asset: asset, gravity: settings.gravity)

        player.delegate = context.coordinator as? PlayerErrorDelegate
        return player
    }
}

#endif

#if canImport(AppKit)
@available(macOS 11, *)
extension LoopPlayerViewProtocol where Self: NSViewRepresentable, Context == NSViewRepresentableContext<Self> {
    
    /// Creates a player view for looping video content.
    /// - Parameters:
    ///   - context: The NSViewRepresentable context providing environment data and coordinator.
    ///   - asset: The AVURLAsset to be used for video playback.
    /// - Returns: A PlayerView instance conforming to LoopingPlayerProtocol.
    func createPlayerView<PlayerView: LoopingPlayerProtocol>(
        context: Context,
        asset: AVURLAsset) -> PlayerView {
        
        let player = PlayerView(asset: asset, gravity: settings.gravity)

            player.delegate = context.coordinator as? PlayerErrorDelegate
        return player
    }
}

#endif

@MainActor
internal class PlayerErrorCoordinator: NSObject, PlayerErrorDelegate {
    
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
