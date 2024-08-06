//
//  MultiPlatformLoopPlayerView.swift
//
//
//  Created by Igor  on 05.08.24.
//

import SwiftUI
#if canImport(AVKit)
import AVKit
#endif

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
struct MultiPlatformLoopPlayerView: View {
    
    /// Settings for the loop player view
    var settings: Settings
    
    /// Unique identifier for the video
    var videoId: String

    var body: some View {
        #if os(iOS) || os(tvOS)
        LoopPlayerViewIOS(settings: settings)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .id(videoId)
        #elseif os(macOS)
        LoopPlayerViewMacOS(settings: settings)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .id(videoId)
        #endif
    }
}
