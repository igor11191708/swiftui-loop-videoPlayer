//
//  LoopingPlayerProtocol.swift
//
//
//  Created by Igor Shelopaev on 05.08.24.
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
public protocol LoopingPlayerProtocol: AbstractPlayer, LayerMakerProtocol{
    
    #if canImport(UIKit)
        var layer : CALayer { get }
    #elseif canImport(AppKit)
        var layer : CALayer? { get set }
        var wantsLayer : Bool { get set }
    #endif
    
    var playerLayer : AVPlayerLayer { get }

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

    /// Initializes a video player with a specified media asset and layer gravity.
    /// - Parameters:
    ///   - asset: The `AVURLAsset` representing the media content to be played. This asset encapsulates the properties of the media file.
    ///   - gravity: The `AVLayerVideoGravity` that determines how the video content is displayed within the bounds of the player layer. Common values are `.resizeAspect`, `.resizeAspectFill`, and `.resize` to control the scaling and filling behavior of the video content.
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
}

extension LoopingPlayerProtocol {
    
    /// Updates the player to play a new asset and handles the playback state.
       ///
       /// This method pauses the player if it was previously playing,
       /// replaces the current player item with a new item created from the provided asset,
       /// and seeks to the start of the new item. It resumes playing if the player was playing before the update.
       ///
       /// - Parameters:
       ///   - asset: The AVURLAsset to load into the player.
    func update(asset: AVURLAsset){
        // Optionally, check if the player is currently playing
        let wasPlaying = player?.rate != 0
        
        // Pause the player if it was playing
        if wasPlaying {
            player?.pause()
        }
        
        removeItemObservers()
        unloop()
        removeAllFilters()
        
        // Replace the current item with a new item created from the asset
        let newItem = AVPlayerItem(asset: asset)
        
        addItemObservers(for: newItem)
        
        player?.replaceCurrentItem(with: newItem)
        
        loop()
        
        // Seek to the beginning of the item if you want to start from the start
        player?.seek(to: .zero, completionHandler: { _ in
            // Resume playing if the player was playing before
            if wasPlaying {
                self.player?.play()
            }
        })
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
        layer.addSublayer(compositeLayer)
        #elseif canImport(AppKit)
        playerLayer.backgroundColor = NSColor.clear.cgColor
        let layer = CALayer()
        layer.addSublayer(playerLayer)
        layer.addSublayer(compositeLayer)
        self.layer = layer
        self.wantsLayer = true
        #endif
        compositeLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        loop()
        player.play()
    }
    
    /// Sets up observers on the player item and the player to track their status and error states.
    ///
    /// - Parameters:
    ///   - item: The player item to observe.
    ///   - player: The player to observe.
    func setupObservers(for item: AVPlayerItem, player: AVQueuePlayer) {
        addItemObservers(for: item)
        errorObserver = player.observe(\.error, options: [.new]) { [weak self] player, _ in
            self?.handlePlayerError(player)
        }
    }
    
    /// Removes the observers associated with the current AVPlayerItem.
    ///
    /// This function invalidates the status observer and removes the notification observer for the AVPlayerItem's end time event.
    func removeItemObservers(){
        // Invalidate and remove the status observer.
        statusObserver?.invalidate()
        statusObserver = nil
        
        // Remove the observer for the AVPlayerItemDidPlayToEndTime notification.
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    /// Adds observers to the specified AVPlayerItem.
    ///
    /// This function observes changes to the status of the AVPlayerItem and registers a handler for status changes.
    /// - Parameter item: The AVPlayerItem to observe.
    func addItemObservers(for item: AVPlayerItem){
        // Observe the status property of the AVPlayerItem and handle changes using the provided closure.
        statusObserver = item.observe(\.status, options: [.new, .old]) { [weak self] item, _ in
            self?.handlePlayerItemStatusChange(item)
            print(item)
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
    
    func setCommand(_ value: PlaybackCommand) {
        /// Sets the playback command for the video player.
        /// - Parameter value: The `PlaybackCommand` to set. This can be one of the following:
        ///   - `play`: Command to play the video.
        ///   - `pause`: Command to pause the video.
        ///   - `seek(to:)`: Command to seek to a specific time in the video.
        ///   - `begin`: Command to position the video at the beginning.
        ///   - `end`: Command to position the video at the end.
        ///   - `mute`: Command to mute the video.
        ///   - `unmute`: Command to unmute the video.
        ///   - `volume`: Command to adjust the volume of the video playback.
        ///   - `subtitles`: Command to set subtitles to a specified language or turn them off.
        ///   - `playbackSpeed`: Command to adjust the playback speed of the video.
        ///   - `loop`: Command to enable looping of the video playback.
        ///   - `unloop`: Command to disable looping of the video playback.
        ///   - `brightness`: Command to adjust the brightness of the video playback.
        ///   - `contrast`: Command to adjust the contrast of the video playback.
        ///   - `filter`: Command to apply a specific Core Image filter to the video.
        ///   - `removeAllFilters`: Command to remove all applied filters from the video playback.
        ///   - `audioTrack`: Command to select a specific audio track based on language code.
        ///   - `vector`: Sets a vector graphic operation on the video player.
        ///   - `removeAllVectors`: Clears all vector graphics from the video player.
        switch value {
        case .play:
            play()
        case .pause:
            pause()
        case .seek(to: let time):
            seek(to: time)
        case .begin:
            seekToStart()
        case .end:
            seekToEnd()
        case .mute:
            mute()
        case .unmute:
            unmute()
        case .volume(let volume):
            setVolume(volume)
        case .subtitles(let language):
            setSubtitles(to: language)
        case .playbackSpeed(let speed):
            setPlaybackSpeed(speed)
        case .loop:
            loop()
        case .unloop:
            unloop()
        case .brightness(let brightness):
            adjustBrightness(to: brightness)
        case .contrast(let contrast):
            adjustContrast(to: contrast)
        case .filter(let value, let clear):
            applyFilter(value, clear)
        case .removeAllFilters:
            removeAllFilters()
        case .audioTrack(let languageCode):
            selectAudioTrack(languageCode: languageCode)
        case .addVector(let builder, let clear):
            addVectorLayer(builder: builder, clear: clear)
        case .removeAllVectors:
            removeAllVectors()
        }
    }
}
