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
@MainActor @preconcurrency
public protocol LoopingPlayerProtocol: AbstractPlayer, LayerMakerProtocol{
    
    #if canImport(UIKit)
        var layer : CALayer { get }
    #elseif canImport(AppKit)
        var layer : CALayer? { get set }
        var wantsLayer : Bool { get set }
    #endif
    
    var playerLayer : AVPlayerLayer { get }
    
    /// An optional NSKeyValueObservation to monitor errors encountered by the video player.
    /// This observer should be configured to detect and handle errors from the AVQueuePlayer,
    /// ensuring that all playback errors are managed and reported appropriately.
    var errorObserver: NSKeyValueObservation? { get set }
    
    /// Observes the status property of the new player item.
    var statusObserver: NSKeyValueObservation? { get set }
    
    /// An optional observer for monitoring changes to the player's `timeControlStatus` property.
    var timeControlObserver: NSKeyValueObservation? { get set }
    
    /// An optional observer for monitoring changes to the player's `currentItem` property.
    var currentItemObserver: NSKeyValueObservation? { get set }

    /// An optional observer for monitoring changes to the player's `volume` property.
    var volumeObserver: NSKeyValueObservation? { get set }
    
    /// Declare a variable to hold the time observer token outside the if statement
    var timeObserver: Any? { get set }

    /// Initializes a new player view with specified video asset and configurations.
    ///
    /// - Parameters:
    ///   - asset: The `AVURLAsset` used for video playback.
    ///   - gravity: The `AVLayerVideoGravity` defining how the video content is displayed within the layer bounds.
    ///   - timePublishing: Optional `CMTime` that specifies a particular time for publishing or triggering an event.
    ///   - loop: A Boolean value that indicates whether the video should loop when playback reaches the end of the content.
    init(asset: AVURLAsset, gravity: AVLayerVideoGravity, timePublishing: CMTime?, loop : Bool)
    
    /// Sets up the necessary observers on the AVPlayerItem and AVQueuePlayer to monitor changes and errors.
    ///
    /// - Parameters:
    ///   - item: The AVPlayerItem to observe for status changes.
    ///   - player: The AVQueuePlayer to observe for errors.
    func setupObservers(for player: AVQueuePlayer)

    /// Responds to errors reported by the AVQueuePlayer.
    ///
    /// - Parameter player: The AVQueuePlayer that encountered an error.
    func handlePlayerError(_ player: AVPlayer)
}

internal extension LoopingPlayerProtocol {
    
    /// Sets up the player components with the specified media asset, display properties, and optional time publishing interval.
    ///
    /// - Parameters:
    ///   - asset: The AVURLAsset representing the video content.
    ///   - gravity: Determines how the video content is scaled or fit within the player view.
    ///   - timePublishing: Optional interval for publishing the current playback time; nil disables this feature.
    func setupPlayerComponents(
        asset: AVURLAsset,
        gravity: AVLayerVideoGravity,
        timePublishing:  CMTime?,
        loop: Bool
    ) {
        
        let player = AVQueuePlayer(items: [])
        self.player = player
        
        update(asset: asset, loop: loop)
        
        configurePlayer(player, gravity: gravity, timePublishing: timePublishing, loop: loop)
        
        setupObservers(for: player)
    }
    
    /// Configures the provided AVQueuePlayer with specific properties for video playback.
    ///
    /// - Parameters:
    ///   - player: The AVQueuePlayer to be configured.
    ///   - gravity: The AVLayerVideoGravity determining how the video content should be scaled or fit within the player layer.
    ///   - timePublishing: Optional interval for publishing the current playback time; nil disables this feature.
    func configurePlayer(
        _ player: AVQueuePlayer,
        gravity: AVLayerVideoGravity,
        timePublishing:  CMTime?,
        loop : Bool
    ) {
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
        
        if let timePublishing{
            timeObserver = player.addPeriodicTimeObserver(forInterval: timePublishing, queue: .main) { [weak self] time in
                guard let self = self else{ return }
                
                self.delegate?.didPassedTime(seconds: time.seconds)
            }
        }
    }
    
    /// Clears all items from the player's queue.
    func clearPlayerQueue() {
        guard let items = player?.items() else { return }
        for item in items {
            player?.remove(item)
        }
    }
    
    /// Updates the current playback asset, settings, and initializes playback or a specific action when the asset is ready.
    ///
    /// This method sets a new asset to be played, optionally loops it, and can automatically start playback.
    /// If provided, a callback is executed when the asset is ready to play.
    ///
    /// - Parameters:
    ///   - asset: The AVURLAsset to be loaded into the player.
    ///   - loop: A Boolean value indicating whether the video should loop.
    ///   - autoPlay: A Boolean value indicating whether playback should start automatically. Default is true.
    ///   - callback: An optional closure to be called when the asset is ready to play.
    func update(asset: AVURLAsset, loop: Bool, autoPlay: Bool = true,  callback: ((AVPlayerItem.Status) -> Void)? = nil) {

        guard let player = player else { return }

        let wasPlaying = player.rate != 0

        if wasPlaying {
            pause()
        }

        if !player.items().isEmpty {
            // Cleaning
            unloop()
            clearPlayerQueue()
            removeAllFilters()
        }

        let newItem = AVPlayerItem(asset: asset)
        player.insert(newItem, after: nil)

        if loop {
            self.loop()
        }

        // Set up state item status observer
        setupStateItemStatusObserver(newItem: newItem, callback: callback)
      
        if autoPlay{
            player.play()
        }
    }
    
    /// Sets up an observer for the status of the provided `AVPlayerItem`.
    ///
    /// This method observes changes in the status of `newItem` and triggers the provided callback
    /// whenever the status changes to `.readyToPlay` or `.failed`. Once the callback is invoked,
    /// the observer is invalidated, ensuring that the callback is called only once.
    ///
    /// - Parameters:
    ///   - newItem: The `AVPlayerItem` whose status is to be observed.
    ///   - callback: A closure that is called when the item's status changes to `.readyToPlay` or `.failed`.
    func setupStateItemStatusObserver(newItem: AVPlayerItem, callback: ((AVPlayerItem.Status) -> Void)?) {
        statusObserver?.invalidate()
        
        if let callback = callback {
            //.unknown: This state is essentially the default, indicating that the player item is new or has not yet attempted to load its assets.
            statusObserver = newItem.observe(\.status, options: [.new, .old]) { [weak self] item, _ in
                guard item.status == .readyToPlay || item.status == .failed else {
                    return
                }
                
                callback(item.status)
                self?.statusObserver?.invalidate()
                self?.statusObserver = nil
            }
        }
    }
    
    /// Sets up observers on the player item and the player to track their status and error states.
    ///
    /// - Parameters:
    ///   - item: The player item to observe.
    ///   - player: The player to observe.
    func setupObservers(for player: AVQueuePlayer) {
        errorObserver = player.observe(\.error, options: [.new]) { [weak self] player, _ in
            self?.handlePlayerError(player)
        }
        
        timeControlObserver = player.observe(\.timeControlStatus, options: [.new, .old]) { [weak self] player, change in
            switch player.timeControlStatus {
            case .paused:
                // This could mean playback has stopped, but it's not specific to end of playback
                self?.delegate?.didPausePlayback()
            case .waitingToPlayAtSpecifiedRate:
                // Player is waiting to play (e.g., buffering)
                self?.delegate?.isWaitingToPlay()
            case .playing:
                // Player is currently playing
                self?.delegate?.didStartPlaying()
            @unknown default:
                break
            }
        }
        
        currentItemObserver = player.observe(\.currentItem, options: [.new, .old]) { [weak self]  player, change in
            // Detecting when the current item is changed
            if let newItem = change.newValue as? AVPlayerItem {
                self?.delegate?.currentItemDidChange(to: newItem)
            } else if change.newValue == nil {
                self?.delegate?.currentItemWasRemoved()
            }
        }
        
        volumeObserver = player.observe(\.volume, options: [.new, .old]) { [weak self]  player, change in
            if let newVolume = change.newValue as? Float {
                self?.delegate?.volumeDidChange(to: newVolume)
            }
        }
    }
    
    /// Removes observers for handling errors.
    ///
    /// This method ensures that the error observer is properly invalidated and the reference is cleared.
    /// It is important to call this method to prevent memory leaks and remove any unwanted side effects
    /// from obsolete observers.
    func removeObservers() {
        errorObserver?.invalidate()
        errorObserver = nil
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
    func setCommand(_ value: PlaybackCommand) {
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
