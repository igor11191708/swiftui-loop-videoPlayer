//
//  PlayerDelegateProtocol.swift
//
//
//  Created by Igor Shelopaev on 05.08.24.
//

import Foundation

/// Protocol to handle player-related errors.
///
/// Conforming to this protocol allows a class to respond to error events that occur within a media player context.
@available(iOS 14, macOS 11, tvOS 14, *)
public protocol PlayerDelegateProtocol: AnyObject {
    /// Called when an error is encountered within the media player.
    ///
    /// This method provides a way for delegate objects to respond to error conditions, allowing them to handle or
    /// display errors accordingly.
    ///
    /// - Parameter error: The specific `VPErrors` instance describing what went wrong.
    @MainActor
    func didReceiveError(_ error: VPErrors)
    
    /// A method that handles the passage of time in the player.
    /// - Parameter seconds: The amount of time, in seconds, that has passed.
    @MainActor
    func didPassedTime(seconds: Double)

    /// A method that handles seeking in the player.
    /// - Parameters:
    ///   - value: A Boolean indicating whether the seek was successful.
    ///   - currentTime: The current time of the player after seeking, in seconds.
    @MainActor
    func didSeek(value: Bool, currentTime: Double)
}
