//
//  PlayerCoordinator.swift
//
//
//  Created by Igor Shelopaev on 06.08.24.
//

import SwiftUI
import Combine

@MainActor
internal class PlayerCoordinator: NSObject, PlayerDelegateProtocol {
           
    let eventPublisher: PassthroughSubject<PlayerEvent, Never>
    
    let timePublisher: PassthroughSubject<Double, Never>
    
    /// Stores the last command applied to the player.
    private var lastCommand: PlaybackCommand?
    
    /// A binding to an optional `VPErrors` instance, used to report errors back to the parent view.
    @Binding private var error: VPErrors?
   

    init(
        _ error: Binding<VPErrors?>,
         timePublisher: PassthroughSubject<Double, Never>,
        eventPublisher: PassthroughSubject<PlayerEvent, Never>
    ) {
        self._error = error
        self.timePublisher = timePublisher
        self.eventPublisher = eventPublisher
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
    
    /// A method that handles the passage of time in the player.
    /// - Parameter seconds: The amount of time, in seconds, that has passed.
    func didPassedTime(seconds : Double) {
        timePublisher.send(seconds)
    }
    
    /// A method that handles seeking in the player.
    /// - Parameters:
    ///   - value: A Boolean indicating whether the seek was successful.
    ///   - currentTime: The current time of the player after seeking, in seconds.
    func didSeek(value: Bool, currentTime : Double) {
        eventPublisher.send(.seek(value, currentTime: currentTime))
    }
    
    /// Called when the player has paused playback.
    ///
    /// This method is triggered when the player's `timeControlStatus` changes to `.paused`.
    @MainActor
    func didPausePlayback(){
        eventPublisher.send(.paused)
    }
    
    /// Called when the player is waiting to play at the specified rate.
    ///
    /// This method is triggered when the player's `timeControlStatus` changes to `.waitingToPlayAtSpecifiedRate`.
    @MainActor
    func isWaitingToPlay(){
        eventPublisher.send(.waitingToPlayAtSpecifiedRate)
    }
    
    /// Called when the player starts or resumes playing.
    ///
    /// This method is triggered when the player's `timeControlStatus` changes to `.playing`.
    @MainActor
    func didStartPlaying(){
        eventPublisher.send(.playing)
    }
}
