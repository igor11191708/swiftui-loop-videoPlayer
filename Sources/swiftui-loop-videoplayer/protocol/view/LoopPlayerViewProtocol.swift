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
    
#if canImport(UIKit)
    associatedtype View : UIView
    #elseif os(macOS)
    associatedtype View : NSView
    #else
    associatedtype View : CustomView
    #endif
    
    associatedtype ErrorView

    #if canImport(UIKit)
        associatedtype PlayerView: LoopingPlayerProtocol, UIView
    #elseif os(macOS)
        associatedtype PlayerView: LoopingPlayerProtocol, NSView
    #else
        associatedtype PlayerView: LoopingPlayerProtocol, CustomView
    #endif
    
    /// Settings for configuring the video player.
    var settings: VideoSettings { get set }
    
    /// Initializes a new instance with the provided settings and playback command.
    ///
    /// - Parameters:
    ///   - settings: A binding to a `VideoSettings` containing configuration details.
    ///   - command: A binding to a `PlaybackCommand` that controls playback actions.
    ///
    /// This initializer sets up the necessary configuration and command bindings for playback functionality.
    init(settings: Binding<VideoSettings>, command: Binding<PlaybackCommand>)
    
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
    
    /// Constructs an error view and adds it to the specified view if an error is present.
    /// - Parameters:
    ///   - view: The view to which the error message view will be added.
    ///   - error: The optional error which, if present, triggers the creation and addition of an error-specific view.
    @MainActor
    func makeErrorView(_ view: View, error: VPErrors?) {
        if let error = error {
            let errorView = errorTpl(error, settings.errorColor, settings.errorFontSize)
            view.addSubview(errorView)
            activateFullScreenConstraints(for: errorView, in: view)
        }
    }
    
    /// Creates a player view for looping video content.
    /// - Parameters:
    ///   - context: The UIViewRepresentable context providing environment data and coordinator.
    ///   - asset: The AVURLAsset to be used for video playback.
    /// - Returns: A PlayerView instance conforming to LoopingPlayerProtocol.
    @MainActor
    func makePlayerView(
        _ container: View,
        asset: AVURLAsset?) -> PlayerView? {
        
        if let asset{
            let player = PlayerView(asset: asset, gravity: settings.gravity)
            container.addSubview(player)
            activateFullScreenConstraints(for: player, in: container)
            return player
        }

        return nil
    }
}
