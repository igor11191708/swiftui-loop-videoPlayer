//
//  PlayerErrorDelegate.swift
//
//
//  Created by Igor  on 05.08.24.
//

import Foundation

/// Protocol to handle player-related errors.
///
/// Conforming to this protocol allows a class to respond to error events that occur within a media player context.
@available(iOS 14, macOS 11, tvOS 14, *)
public protocol PlayerErrorDelegate: AnyObject {
    /// Called when an error is encountered within the media player.
    ///
    /// This method provides a way for delegate objects to respond to error conditions, allowing them to handle or
    /// display errors accordingly.
    ///
    /// - Parameter error: The specific `VPErrors` instance describing what went wrong.
    @MainActor
    func didReceiveError(_ error: VPErrors)
}
