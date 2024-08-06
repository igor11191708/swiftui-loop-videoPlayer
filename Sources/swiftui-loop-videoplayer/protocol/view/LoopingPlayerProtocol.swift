//
//  LoopingPlayerProtocol.swift
//
//
//  Created by Igor  on 05.08.24.
//

import AVFoundation
import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
/// A protocol defining the requirements for a looping video player.
///
/// Conforming types are expected to manage a video player that can loop content continuously,
/// handle errors, and notify a delegate of important events.
@available(iOS 14, macOS 11, tvOS 14, *)
@MainActor
public protocol LoopingPlayerProtocol: AnyObject {
    
    var playerLayer : AVPlayerLayer { get }
    
    #if canImport(UIKit)
        var layer : CALayer { get }
    #elseif canImport(AppKit)
        var layer : CALayer? { get set }
        var wantsLayer : Bool { get set }
    #endif
    
    /// The looper responsible for continuous video playback.
    var playerLooper: AVPlayerLooper? { get set }

    /// The queue player that plays the video items.
    var player: AVQueuePlayer? { get set }

    /// The delegate to be notified about errors encountered by the player.
    var delegate: PlayerErrorDelegate? { get set }
    
    /// An optional NSKeyValueObservation to monitor changes in the playback status of the video.
    /// This observer should be set up to watch for changes such as play, pause, or errors in the AVPlayerItem,
    /// allowing the conforming object to respond to different states of the video playback.
    var statusObserver: NSKeyValueObservation? { get set }

    /// An optional NSKeyValueObservation to monitor errors encountered by the video player.
    /// This observer should be configured to detect and handle errors from the AVQueuePlayer,
    /// ensuring that all playback errors are managed and reported appropriately.
    var errorObserver: NSKeyValueObservation? { get set }

    init(asset: AVURLAsset, gravity: AVLayerVideoGravity)
    
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
    
    // Playback control methods

    /// Initiates or resumes playback of the video.
    /// This method should be implemented to start playing the video from its current position.
    func play()

    /// Pauses the current video playback.
    /// This method should be implemented to pause the video, allowing it to be resumed later from the same position.
    func pause()

    /// Seeks to a specific point in the video.
    /// This method should be implemented to allow seeking to a particular time within the video.
    /// - Parameter time: The CMTime representing the target position to seek to in the video.
    func seek(to time: CMTime)
}

extension LoopingPlayerProtocol {
    
    
    // Implementations of playback control methods

    /// Initiates playback of the video.
    /// This method starts or resumes playing the video from the current position.
    func play() {
        player?.play()
    }

    /// Pauses the video playback.
    /// This method pauses the video if it is currently playing, allowing it to be resumed later from the same position.
    func pause() {
        player?.pause()
    }

    /// Seeks the video to a specific time.
    /// This method moves the playback position to the specified time with precise accuracy.
    /// - Parameter time: The target time to seek to in the video timeline.
    func seek(to time: CMTime) {
        player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
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
    
    /// Configures the provided AVQueuePlayer with specific properties for video playback.
    ///
    /// This method sets the video gravity and muted state of the player, and assigns it to a player layer.
    /// It is intended to set up the player with the necessary configuration for video presentation based on the given gravity.
    /// - Parameters:
    ///   - player: The AVQueuePlayer to be configured.
    ///   - gravity: The AVLayerVideoGravity determining how the video content should be scaled or fit within the player layer.
    internal func configurePlayer(_ player: AVQueuePlayer, gravity: AVLayerVideoGravity) {
        player.isMuted = true
        playerLayer.player = player
        playerLayer.videoGravity = gravity
        #if canImport(UIKit)
        playerLayer.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(playerLayer)
        #elseif canImport(AppKit)
        playerLayer.backgroundColor = NSColor.clear.cgColor
        layer = CALayer()
        layer?.addSublayer(playerLayer)
        wantsLayer = true
        #endif
        
        if let firstItem = player.items().first {
            playerLooper = AVPlayerLooper(player: player, templateItem: firstItem)
        }
        player.play()
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
