//
//  LoopingPlayerNSView.swift
//
//
//  Created by Igor  on 05.08.24.
//

import SwiftUI

#if canImport(AVKit)
import AVKit
#endif

#if canImport(AppKit)
import AppKit

/// A NSView subclass that loops video using AVFoundation on macOS.
/// This class handles the initialization and management of a looping video player with customizable video gravity.
@available(macOS 11.0, *)
@MainActor @preconcurrency
class LoopingPlayerNSView: NSView, LoopingPlayerProtocol {   
    
    /// `filters` is an array that stores CIFilter objects used to apply different image processing effects
    internal var filters: [CIFilter] = []

    /// `brightness` represents the adjustment level for the brightness of the video content.
    internal var brightness: Float = 0

    /// `contrast` indicates the level of contrast adjustment for the video content.
    internal var contrast: Float = 1
    
    /// A CALayer instance used for composing content, accessible only within the module.
    internal let compositeLayer = CALayer()
    
    /// The AVPlayerLayer that displays the video content.
    internal let playerLayer = AVPlayerLayer()
    
    /// The looper responsible for continuous video playback.
    internal var playerLooper: AVPlayerLooper?
    
    /// The queue player that plays the video items.
    internal var player: AVQueuePlayer?
    
    /// Declare a variable to hold the time observer token outside the if statement
    internal var timeObserverToken: Any?
    
    /// A Boolean value indicating whether the player is currently seeking to a new time.
    internal var isSeeking: Bool = false
    
    /// Observer for errors from the AVQueuePlayer.
    internal var errorObserver: NSKeyValueObservation?
    
    /// The delegate to be notified about errors encountered by the player.
    weak var delegate: PlayerDelegateProtocol?

    /// Initializes a new instance of the view
    ///
    /// - Parameters:
    ///   - asset: The AVURLAsset to be used in the player.
    ///   - gravity: Specifies how the video content should be displayed within the layer bounds.
    ///   - timePublishing: Optional CMTime that determines the interval at which the video current time should be published. Pass nil to disable time publishing.
    required init(asset: AVURLAsset, gravity: AVLayerVideoGravity, timePublishing: CMTime?) {
        super.init(frame: .zero)
        setupPlayerComponents(
            asset: asset, gravity: gravity, timePublishing: timePublishing
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Lays out subviews and adjusts the frame of the player layer to match the view's bounds.
    override func layout() {
        super.layout()
        playerLayer.frame = bounds
    }

    /// Cleans up resources and observers associated with the player.
    ///
    /// This method invalidates the status and error observers to prevent memory leaks,
    /// pauses the player, and clears out player-related references to assist in clean deinitialization.
    deinit {
        cleanUp(player: &player, playerLooper: &playerLooper, errorObserver: &errorObserver, timeObserverToken: &timeObserverToken)
    }
}
#endif
