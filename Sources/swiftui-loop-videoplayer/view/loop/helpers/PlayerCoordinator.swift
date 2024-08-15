//
//  PlayerCoordinator.swift
//
//
//  Created by Igor  on 06.08.24.
//

import SwiftUI
import Combine

@MainActor
internal class PlayerCoordinator: NSObject, PlayerDelegateProtocol {
    
    let timePublisher: PassthroughSubject<Double, Never>
    
    /// Stores the last command applied to the player.
    private var lastCommand: PlaybackCommand?
    
    /// A binding to an optional `VPErrors` instance, used to report errors back to the parent view.
    @Binding private var error: VPErrors?
   
    /// Initializes a new instance of `PlayerCoordinator`.
    /// - Parameter error: A binding to an optional `VPErrors` instance to manage error reporting.
    init(_ error: Binding<VPErrors?>, timePublisher: PassthroughSubject<Double, Never>) {
        self._error = error
        self.timePublisher = timePublisher
    }
    
    /// Deinitializes the coordinator and prints a debug message if in DEBUG mode.
    deinit {
        #if DEBUG
        print("deinit Coordinator")
        #endif
    }
    
    /// Handles receiving an error and updates the error state in the parent view.
    /// This method is called when an error is encountered during playback or other operations.
    /// - Parameter error: The error received.
    func didReceiveError(_ error: VPErrors) {
        self.error = error
    }
    
    /// Sets the last command applied to the player.
    /// This method updates the stored `lastCommand` to the provided value.
    /// - Parameter command: The `PlaybackCommand` that was last applied to the player.
    func setLastCommand(_ command: PlaybackCommand) {
        self.lastCommand = command
    }
    
    /// Retrieves the last command applied to the player.
    /// - Returns: The `PlaybackCommand` that was last applied to the player.
    var getLastCommand : PlaybackCommand? {
        return lastCommand
    }
    
    func didPassedTime(seconds : Double) {
        timePublisher.send(seconds)
    }
}
