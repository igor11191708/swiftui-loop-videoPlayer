//
//  LoopingPlayerProtocol.swift
//
//
//  Created by Igor  on 05.08.24.
//

import SwiftUI

#if canImport(AVKit)
import AVKit
#endif

#if canImport(UIKit)
import UIKit

@available(iOS 14.0, tvOS 14.0, *)
@MainActor @preconcurrency
class LoopingPlayerUIView: UIView, LoopingPlayerProtocol {
    
    /// `filters` is an array that stores CIFilter objects used to apply different image processing effects
    internal var filters: [CIFilter] = []

    /// `brightness` represents the adjustment level for the brightness of the video content.
    internal var brightness: Float = 0

    /// `contrast` indicates the level of contrast adjustment for the video content.
    internal var contrast: Float = 1
    
    internal let compositeLayer = CALayer()
    
    /// The AVPlayerLayer that displays the video content.
    internal let playerLayer = AVPlayerLayer()
    
    /// The looper responsible for continuous video playback.
    internal var playerLooper: AVPlayerLooper?
    
    /// The queue player that plays the video items.
    internal var player: AVQueuePlayer?
    
    /// Observer for the status of the AVPlayerItem.
    internal var statusObserver: NSKeyValueObservation?
    
    /// Observer for errors from the AVQueuePlayer.
    internal var errorObserver: NSKeyValueObservation?
    
    /// The delegate to be notified about errors encountered by the player.
    weak var delegate: PlayerErrorDelegate?

    /// Initializes a new looping video player view with the specified asset and gravity.
    ///
    /// - Parameters:
    ///   - asset: The AVURLAsset to be played.
    ///   - gravity: The AVLayerVideoGravity to be applied to the video layer.
    required init(asset: AVURLAsset, gravity: AVLayerVideoGravity) {
        super.init(frame: .zero)
        setupPlayerComponents(asset: asset, gravity: gravity)        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Lays out subviews and adjusts the frame of the player layer to match the view's bounds.
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    /// Cleans up resources and observers associated with the player.
    ///
    /// This method invalidates the status and error observers to prevent memory leaks,
    /// pauses the player, and clears out player-related references to assist in clean deinitialization.
    deinit {
        cleanUp()
    }
}
#endif
