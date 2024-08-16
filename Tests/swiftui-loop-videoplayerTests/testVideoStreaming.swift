//
//  testVideoStreaming.swift
//  
//
//  Created by Igor  on 16.08.24.
//

import XCTest
import SwiftUI
@testable import swiftui_loop_videoplayer

final class testVideoStreaming: XCTestCase {

    func testLocalVideoStreaming() {

        guard let filePath = Bundle.module.path(forResource: "swipe", ofType: "mp4") else {
            XCTFail("Missing file: swipe.mp4")
            return
        }
        
        let _ = ExtPlayerView(fileName: filePath)
        // Use the filePath as needed for your tests
        print("Video file path: \(filePath)")

    }
}
