//
//  testPlaybackCommandChangesOverTime.swift
//  
//
//  Created by Igor Shelopaev on 16.08.24.
//

import XCTest
import SwiftUI
@testable import swiftui_loop_videoplayer
import AVKit

final class testPlaybackCommandChangesOverTime: XCTestCase {

    func testPlaybackCommandChangesOverTime() {
        // Setup initial command and a binding
        let initialCommand = PlaybackCommand.play
        var command = initialCommand
        let commandBinding = Binding(
            get: { command },
            set: { command = $0 }
        )

        // Create an instance of the view with the initial command
        let playerView = ExtVideoPlayer(fileName: "swipe", command: commandBinding)

        // Setup expectation for asynchronous test
        let expectation = self.expectation(description: "Command should change to .pause")

        // Change the command after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            commandBinding.wrappedValue = .pause
        }

        // Periodically check if the command has changed
        let checkInterval = 0.1 // Check every 0.1 seconds
        var timeElapsed = 0.0
        Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { timer in
            if command == .pause {
                timer.invalidate()
                expectation.fulfill()
            } else if timeElapsed >= 5 { // Failsafe timeout
                timer.invalidate()
                XCTFail("Command did not change within the expected time")
            }
            timeElapsed += checkInterval
        }

        // Wait for the expectation to be fulfilled, or time out after 10 seconds
        waitForExpectations(timeout: 5, handler: nil)

        // Verify the command has indeed changed
        XCTAssertEqual(playerView.command, .pause, "Playback command should have updated to .pause")
    }

}
