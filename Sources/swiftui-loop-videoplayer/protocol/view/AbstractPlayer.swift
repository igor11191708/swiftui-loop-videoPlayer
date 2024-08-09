//
//  AbstractPlayer.swift
//
//
//  Created by Igor Shelopaev on 07.08.24.
//

import AVFoundation
import Foundation

@available(iOS 14, macOS 11, tvOS 14, *)
public protocol AbstractPlayer: AnyObject{
    
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
}

extension AbstractPlayer{
    
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
        if let duration = player?.currentItem?.duration {
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
        guard let currentItem = player?.currentItem,
              let group = currentItem.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else {
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
    }
    
    /// Enables looping for the current video item.
    /// This method sets up the `playerLooper` to loop the currently playing item indefinitely.
    func loop() {
        guard let player = player, let currentItem = player.currentItem else {
            return
        }

        // Check if the video is already being looped
        if playerLooper != nil {
            return // Already looped, no need to loop again
        }

        // Initialize the player looper with the current item
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
        }
    }
}
