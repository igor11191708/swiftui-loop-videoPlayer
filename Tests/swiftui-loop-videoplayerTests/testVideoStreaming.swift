//
//  testVideoStreaming.swift
//  
//
//  Created by Igor Shelopaev on 16.08.24.
//

import XCTest
@testable import swiftui_loop_videoplayer

final class testVideoStreaming: XCTestCase {

    
    func testLocalVideoStreaming() {

           // Setup player with video
           guard let filePath = Bundle.module.path(forResource: "swipe", ofType: "mp4") else {
               XCTFail("Missing file: swipe.mp4")
               return
           }
        
        let playerView = ExtVideoPlayer(fileName: filePath)

    }
}
