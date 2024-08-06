//
//  PlaybackCommand.swift
//
//
//  Created by Igor  on 06.08.24.
//

import AVFoundation

/// An enumeration of possible playback commands.
enum PlaybackCommand {
    /// Command to play the video.
    case play
    
    /// Command to pause the video.
    case pause
    
    /// Command to seek to a specific time in the video.
    /// - Parameter time: The CMTime representing the target position to seek to in the video.
    case seek(to: CMTime)
}
