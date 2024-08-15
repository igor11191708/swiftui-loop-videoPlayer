//
//  AbstractPlayer.swift
//
//
//  Created by Igor Shelopaev on 07.08.24.
//

import AVFoundation
#if canImport(CoreImage)
import CoreImage
#endif

@available(iOS 14, macOS 11, tvOS 14, *)
@MainActor @preconcurrency
public protocol AbstractPlayer: AnyObject {
    
    /// Retrieves the current item being played.
    var currentItem : AVPlayerItem? { get }
    
    /// The current asset being played, if available.
    var currentAsset : AVURLAsset? { get }
    
    /// Adjusts the brightness of the video. Default is 0 (no change), with positive values increasing and negative values decreasing brightness.
    var brightness: Float { get set }

    /// Controls the contrast of the video. Default is 1 (no change), with values above 1 enhancing and below 1 reducing contrast.
    var contrast: Float { get set }

    /// Holds an array of CIFilters to be applied to the video. Filters are applied in the order they are added to the array.
    var filters: [CIFilter] { get set }
    
    /// The looper responsible for continuous video playback.
    var playerLooper: AVPlayerLooper? { get set }
    
    /// The queue player that plays the video items.
    var player: AVQueuePlayer? { get set }
    
    // Playback control methods

    /// Initiates or resumes playback of the video.
    /// This method should be implemented to start playing the video from its current position.
    func play()

    /// Pauses the current video playback.
    /// This method should be implemented to pause the video, allowing it to be resumed later from the same position.
    func pause()

    /// Seeks the video to a specific time.
    /// This method moves the playback position to the specified time with precise accuracy.
    /// - Parameter time: The target time to seek to in the video timeline.
    func seek(to time: Double)
    
    /// Seeks to the start of the video.
    /// This method positions the playback at the beginning of the video.
    func seekToStart()
    
    /// Seeks to the end of the video.
    /// This method positions the playback at the end of the video.
    func seekToEnd()
    
    /// Mutes the video playback.
    /// This method silences the audio of the video.
    func mute()
    
    /// Unmutes the video playback.
    /// This method restores the audio of the video.
    func unmute()

    /// Adjusts the volume for the video playback.
    /// - Parameter volume: A `Float` value between 0.0 (mute) and 1.0 (full volume).
    /// If the value is out of range, it will be clamped to the nearest valid value.
    func setVolume(_ volume: Float)

    /// Adjusts the brightness of the video playback.
    /// - Parameter brightness: A `Float` value representing the brightness level. Typically ranges from -1.0 to 1.0.
    func adjustBrightness(to brightness: Float)

    /// Adjusts the contrast of the video playback.
    /// - Parameter contrast: A `Float` value representing the contrast level. Typically ranges from 0.0 to 4.0.
    func adjustContrast(to contrast: Float)

    /// Applies a Core Image filter to the video player's content.
    func applyFilter(_ value: CIFilter, _ clear : Bool)

    /// Removes all filters from the video playback.
    func removeAllFilters(apply : Bool)

    /// Selects an audio track for the video playback.
    /// - Parameter languageCode: The language code (e.g., "en" for English) of the desired audio track.
    func selectAudioTrack(languageCode: String)

    /// Sets the playback command for the video player.
    func setCommand(_ value: PlaybackCommand)
    
    func applyVideoComposition()
}

extension AbstractPlayer{

    /// Retrieves the current item being played.
    ///
    /// This computed property checks if there is a current item available in the player.
    /// If available, it returns the `currentItem`; otherwise, it returns `nil`.
    var currentItem : AVPlayerItem?{
        if let currentItem = player?.currentItem {
            return currentItem
        }
        return nil
    }
    
    /// The current asset being played, if available.
    ///
    /// This computed property checks the current item of the player.
    /// If the current item exists and its asset can be cast to AVURLAsset,
    var currentAsset : AVURLAsset?{
        if let currentItem = currentItem {
            return currentItem.asset as? AVURLAsset
        }
        return nil
    }
    
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
    /// If the specified time is out of bounds, it will be clamped to the nearest valid time.
    /// - Parameter time: The target time to seek to in the video timeline.
    func seek(to time: Double) {
        guard let player = player, let duration = player.currentItem?.duration else {
            return
        }
        
        let endTime = CMTimeGetSeconds(duration)
        
        if time < 0 {
            // If the time is negative, seek to the start of the video
            player.seek(to: .zero)
        } else if time > endTime {
            // If the time exceeds the video duration, seek to the end of the video
            let endCMTime = CMTime(seconds: endTime, preferredTimescale: duration.timescale)
            player.seek(to: endCMTime)
        } else {
            // Otherwise, seek to the specified time
            let seekCMTime = CMTime(seconds: time, preferredTimescale: duration.timescale)
            player.seek(to: seekCMTime)
        }
    }
    
    /// Seeks to the start of the video.
    /// This method positions the playback at the beginning of the video.
    func seekToStart() {
        seek(to: 0)
    }
    
    /// Seeks to the end of the video.
    /// This method positions the playback at the end of the video.
    func seekToEnd() {
        if let duration = currentItem?.duration {
            let endTime = CMTimeGetSeconds(duration)
            seek(to: endTime)
        }
    }
    
    /// Mutes the video playback.
    /// This method silences the audio of the video.
    func mute() {
        player?.isMuted = true
    }
    
    /// Unmutes the video playback.
    /// This method restores the audio of the video.
    func unmute() {
        player?.isMuted = false
    }
    
    /// Sets the volume for the video playback.
    /// - Parameter volume: A `Float` value between 0.0 (mute) and 1.0 (full volume).
    /// If the value is out of range, it will be clamped to the nearest valid value.
    func setVolume(_ volume: Float) {
        let clampedVolume = max(0.0, min(volume, 1.0))  // Clamp the value between 0.0 and 1.0
        player?.volume = clampedVolume
    }
    
    /// Sets the playback speed for the video playback.
    /// - Parameter speed: A `Float` value representing the playback speed (e.g., 1.0 for normal speed, 0.5 for half speed, 2.0 for double speed).
    /// If the value is out of range (negative), it will be clamped to the nearest valid value.
    func setPlaybackSpeed(_ speed: Float) {
        let clampedSpeed = max(0.0, speed)  // Clamp to non-negative values, or adjust the upper bound as needed
        player?.rate = clampedSpeed
    }

    /// Sets the subtitles for the video playback to a specified language or turns them off.
    /// - Parameters:
    ///   - language: The language code (e.g., "en" for English) for the desired subtitles.
    ///               Pass `nil` to turn off subtitles.
    func setSubtitles(to language: String?) {
        #if !os(visionOS)
        guard let currentItem = currentItem,
              let group = currentAsset?.mediaSelectionGroup(forMediaCharacteristic: .legible) else {
            return
        }

        if let language = language {
            // Filter the subtitle options based on the language code
            let options = group.options.filter { option in
                guard let locale = option.locale else { return false }
                return locale.languageCode == language
            }
            // Select the first matching subtitle option
            if let option = options.first {
                currentItem.select(option, in: group)
            }
        } else {
            // Turn off subtitles by deselecting any option in the legible media selection group
            currentItem.select(nil, in: group)
        }
        #endif
    }
    
    /// Enables looping for the current video item.
    /// This method sets up the `playerLooper` to loop the currently playing item indefinitely.
    func loop() {
        guard let player = player, let currentItem = player.currentItem else {
            return
        }

        // Check if the video is already being looped
        if playerLooper != nil {
            return
        }

        playerLooper = AVPlayerLooper(player: player, templateItem: currentItem)
    }
    
    /// Disables looping for the current video item.
    /// This method removes the `playerLooper`, stopping the loop.
    func unloop() {
        // Check if the video is not looped (i.e., playerLooper is nil)
        guard playerLooper != nil else {
            return // Not looped, no need to unloop
        }

        playerLooper?.disableLooping()
        playerLooper = nil
    }

    /// Adjusts the brightness of the video playback.
    /// - Parameter brightness: A `Float` value representing the brightness level. Typically ranges from -1.0 to 1.0.
    func adjustBrightness(to brightness: Float) {
        let clampedBrightness = max(-1.0, min(brightness, 1.0))  // Clamp brightness to the range [-1.0, 1.0]
        self.brightness = clampedBrightness
        applyVideoComposition()
    }

    /// Adjusts the contrast of the video playback.
    /// - Parameter contrast: A `Float` value representing the contrast level. Typically ranges from 0.0 to 4.0.
    func adjustContrast(to contrast: Float) {
        let clampedContrast = max(0.0, min(contrast, 4.0))  // Clamp contrast to the range [0.0, 4.0]
        self.contrast = clampedContrast
        applyVideoComposition()
    }

    /// Applies a Core Image filter to the video playback.
    /// This function adds the provided filter to the stack of existing filters and updates the video composition accordingly.
    /// - Parameter value: A `CIFilter` object representing the filter to be applied to the video playback.
    func applyFilter(_ value: CIFilter, _ clear : Bool) {
        if clear{
            removeAllFilters(apply: false)
        }
        appendFilter(value) // Appends the provided filter to the current stack.
        applyVideoComposition() // Updates the video composition to include the new filter.
    }
    
    /// Appends a Core Image filter to the current list of filters.
    /// - Parameters:
    ///   - value: Core Image filter to be applied.
    private func appendFilter(_ value: CIFilter) {
        filters.append(value)
    }


    /// Removes all applied CIFilters from the video playback.
    ///
    /// This function clears the array of filters and optionally re-applies the video composition
    /// to ensure the changes take effect immediately.
    ///
    /// - Parameters:
    ///   - apply: A Boolean value indicating whether to immediately apply the video composition after removing the filters.
    ///            Defaults to `true`.
    func removeAllFilters(apply : Bool = true) {
        
        guard !filters.isEmpty else { return }
        
        filters = []
        
        if apply{
            applyVideoComposition()
        }
    }
    
    /// Applies the current set of filters to the video using an AVVideoComposition.
    /// This method combines the existing filters and brightness/contrast adjustments, creates a new video composition,
    /// and assigns it to the current AVPlayerItem. The video is paused during this process to ensure smooth application.
    /// This method is not supported on Vision OS.
    func applyVideoComposition() {
        guard let player = player else { return }
        let allFilters = combineFilters(filters, brightness, contrast)
        
        #if !os(visionOS)
        // Optionally, check if the player is currently playing
        let wasPlaying = player.rate != 0
        
        // Pause the player if it was playing
        if wasPlaying {
            player.pause()
        }
               
        player.items().forEach{ item in
            
            let videoComposition = AVVideoComposition(asset: item.asset, applyingCIFiltersWithHandler: { request in
                handleVideoComposition(request: request, filters: allFilters)
            })

            item.videoComposition = videoComposition
        }
        
        if wasPlaying{
            player.play()
        }
        
        #endif
    }

    /// Selects an audio track for the video playback.
    /// - Parameter languageCode: The language code (e.g., "en" for English) of the desired audio track.
    func selectAudioTrack(languageCode: String) {
        guard let currentItem = currentItem else { return }
        #if !os(visionOS)
        // Retrieve the media selection group for audible tracks
        if let group = currentAsset?.mediaSelectionGroup(forMediaCharacteristic: .audible) {
            
            // Filter options by language code using Locale
            let options = group.options.filter { option in
                return option.locale?.languageCode == languageCode
            }
            
            // Select the first matching option, if available
            if let option = options.first {
                currentItem.select(option, in: group)
            }
        }
        #endif
    }

}

/// Cleans up resources associated with an AVQueuePlayer and its related components.
/// This function stops the player, invalidates and clears the observer, and removes all items from the player queue.
/// It also disables any looping mechanisms before setting the player and its components to nil, ensuring proper deinitialization.
///
/// - Parameters:
///   - player: A reference to the AVQueuePlayer to be cleaned up. Modified directly to deallocate resources.
///   - playerLooper: A reference to the AVPlayerLooper associated with the player. It's disabled and set to nil.
///   - errorObserver: A reference to an NSKeyValueObservation monitoring the player, which is invalidated and set to nil.
internal func cleanUp(player: inout AVQueuePlayer?, playerLooper: inout AVPlayerLooper?, errorObserver: inout NSKeyValueObservation?, timeObserverToken: inout Any?) {
    errorObserver?.invalidate()
    errorObserver = nil

    player?.pause()
    
    playerLooper?.disableLooping()
    playerLooper = nil

    guard let items = player?.items() else { return }
    for item in items {
        player?.remove(item)
    }
    
    if let observerToken = timeObserverToken {
        player?.removeTimeObserver(observerToken)
        timeObserverToken = nil
    }
    
    player = nil

    #if DEBUG
    print("Cleaned up.")
    #endif
}
