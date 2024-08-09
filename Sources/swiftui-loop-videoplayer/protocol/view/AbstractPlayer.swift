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
    /// - Parameter time: The target time to seek to in the video timeline.
    func seek(to time: Double) {
        seekToTime(player: player, seekTimeInSeconds: time)
    }
    
    /// Seeks to the start of the video.
    /// This method positions the playback at the beginning of the video.
    func seekToStart() {
        seekToTime(player: player, seekTimeInSeconds: 0)
    }
    
    /// Seeks to the end of the video.
    /// This method positions the playback at the end of the video.
    func seekToEnd() {
        if let duration = player?.currentItem?.duration {
            let endTime = CMTimeGetSeconds(duration)
            seekToTime(player: player, seekTimeInSeconds: endTime)
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
    
   /// Sets the playback command for the video player.
   /// - Parameter value: The `PlaybackCommand` to set. This can be one of the following:
   ///   - `play`: Command to play the video.
   ///   - `pause`: Command to pause the video.
   ///   - `seek(to:)`: Command to seek to a specific time in the video.
   ///   - `begin`: Command to position the video at the beginning.
   ///   - `end`: Command to position the video at the end.
   ///   - `mute`: Command to mute the video.
   ///   - `unmute`: Command to unmute the video.
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
       }
   }
}
