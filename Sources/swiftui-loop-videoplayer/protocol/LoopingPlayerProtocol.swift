//
//  LoopingPlayerProtocol.swift
//
//
//  Created by Igor  on 05.08.24.
//

import AVFoundation
import Foundation

/// A protocol defining the requirements for a looping video player.
///
/// Conforming types are expected to manage a video player that can loop content continuously,
/// handle errors, and notify a delegate of important events.
@available(iOS 14, macOS 11, tvOS 14, *)
@MainActor
public protocol LoopingPlayerProtocol: AnyObject {
    /// The looper responsible for continuous video playback.
    var playerLooper: AVPlayerLooper? { get set }

    /// The queue player that plays the video items.
    var player: AVQueuePlayer? { get set }

    /// The delegate to be notified about errors encountered by the player.
    var delegate: PlayerErrorDelegate? { get set }
    
    var statusObserver: NSKeyValueObservation? { get set }
    var errorObserver: NSKeyValueObservation? { get set }

    /// Sets up the necessary observers on the AVPlayerItem and AVQueuePlayer to monitor changes and errors.
    ///
    /// - Parameters:
    ///   - item: The AVPlayerItem to observe for status changes.
    ///   - player: The AVQueuePlayer to observe for errors.
    func setupObservers(for item: AVPlayerItem, player: AVQueuePlayer)

    /// Responds to changes in the playback status of an AVPlayerItem.
    ///
    /// - Parameter item: The AVPlayerItem whose status changed.
    func handlePlayerItemStatusChange(_ item: AVPlayerItem)

    /// Responds to errors reported by the AVQueuePlayer.
    ///
    /// - Parameter player: The AVQueuePlayer that encountered an error.
    func handlePlayerError(_ player: AVPlayer)
    
    
    /// Configures the provided AVQueuePlayer with specific properties for video playback.
    /// - Parameters:
    ///   - player: The AVQueuePlayer to be configured.
    ///   - gravity: The AVLayerVideoGravity determining how the video content should be scaled or fit within the player layer.
    func configurePlayer(_ player: AVQueuePlayer, gravity: AVLayerVideoGravity)
}

extension LoopingPlayerProtocol {
    
    
    /// Sets up the player components using the provided asset and video gravity.
    ///
    /// This method initializes an AVPlayerItem with the provided asset,
    /// configures an AVQueuePlayer for playback, sets up the player for the view,
    /// and adds necessary observers to monitor playback status and errors.
    ///
    /// - Parameters:
    ///   - asset: The AVURLAsset to be played.
    ///   - gravity: The AVLayerVideoGravity to be applied to the video layer.
    func setupPlayerComponents(asset: AVURLAsset, gravity: AVLayerVideoGravity) {
        // Create an AVPlayerItem with the provided asset
        let item = AVPlayerItem(asset: asset)
        
        // Initialize an AVQueuePlayer with the player item
        let player = AVQueuePlayer(items: [item])
        self.player = player
        
        // Configure the player with the specified gravity
        configurePlayer(player, gravity: gravity)
        
        // Set up observers to monitor status and errors
        setupObservers(for: item, player: player)
    }
    
    /// Sets up observers on the player item and the player to track their status and error states.
    ///
    /// - Parameters:
    ///   - item: The player item to observe.
    ///   - player: The player to observe.
    func setupObservers(for item: AVPlayerItem, player: AVQueuePlayer) {
        statusObserver = item.observe(\.status, options: [.new]) { [weak self] item, _ in
            self?.handlePlayerItemStatusChange(item)
        }
        
        errorObserver = player.observe(\.error, options: [.new]) { [weak self] player, _ in
            self?.handlePlayerError(player)
        }
    }

    /// Responds to changes in the status of an AVPlayerItem.
    ///
    /// This method checks if the status of the AVPlayerItem indicates a failure.
    /// If a failure occurs, it notifies the delegate about the error.
    /// - Parameter item: The AVPlayerItem whose status has changed to be evaluated.
    func handlePlayerItemStatusChange(_ item: AVPlayerItem) {
        guard item.status == .failed, let error = item.error else { return }
        delegate?.didReceiveError(.remoteVideoError(error))
    }

    /// Responds to errors reported by the AVPlayer.
    ///
    /// If an error is present, this method notifies the delegate of the encountered error,
    /// encapsulated within a `remoteVideoError`.
    /// - Parameter player: The AVPlayer that encountered an error to be evaluated.
    func handlePlayerError(_ player: AVPlayer) {
        guard let error = player.error else { return }
        delegate?.didReceiveError(.remoteVideoError(error))
    }
}
