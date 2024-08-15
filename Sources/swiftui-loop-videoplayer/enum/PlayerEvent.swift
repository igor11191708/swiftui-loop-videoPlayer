//
//  PlayerEvents.swift
//
//
//  Created by Igor  on 15.08.24.
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
    
}
