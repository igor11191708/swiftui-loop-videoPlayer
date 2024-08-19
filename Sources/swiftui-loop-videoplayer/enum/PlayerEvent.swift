//
//  PlayerEvents.swift
//
//
//  Created by Igor Shelopaev on 15.08.24.
//

import Foundation

/// An enumeration representing various events that can occur within a media player.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public enum PlayerEvent: Equatable {
    
    /// Represents a state where the player is idle.
    case idle

    /// Represents an end seek action within the player.
    /// - Parameters:
    ///   - Bool: Indicates whether the seek was successful.
    ///   - currentTime: The time (in seconds) to which the player is seeking.
    case seek(Bool, currentTime: Double)
    
    /// Indicates that the player's playback is currently paused.
    ///
    /// This state occurs when the player has been manually paused by the user or programmatically
    /// through a method like `pause()`. The player is not playing any content while in this state.
    case paused

    /// Indicates that the player is currently waiting to play at the specified rate.
    ///
    /// This state generally occurs when the player is buffering or waiting for sufficient data
    /// to continue playback. It can also occur if the playback rate is temporarily reduced to zero
    /// due to external factors, such as network conditions or system resource limitations.
    case waitingToPlayAtSpecifiedRate

    /// Indicates that the player is actively playing content.
    ///
    /// This state occurs when the player is currently playing video or audio content at the
    /// specified playback rate. This is the active state where media is being rendered to the user.
    case playing
}
