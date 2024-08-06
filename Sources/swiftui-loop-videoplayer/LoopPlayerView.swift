//
//  PlayerView.swift
//
//
//  Created by Igor on 10.02.2023.
//

import SwiftUI
#if canImport(AVKit)
import AVKit
#endif

/// Player view for running a video in loop
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct LoopPlayerView: View {
    
    /// Set of settings for video the player
    public let settings: Settings
    
    private var videoId : String{
        [settings.name, settings.ext].joined(separator: ".")
    }
    
    // MARK: - Life cycle
    
    /// Player initializer
    /// - Parameters:
    ///   - fileName: Name of the video to play
    ///   - ext: Video extension
    ///   - gravity: A structure that defines how a layer displays a player’s visual content within the layer’s bounds
    ///   - eText: Error message text if file is not found
    ///   - eFontSize: Size of the error text
    public init(
        fileName: String,
        ext: String = "mp4",
        gravity: AVLayerVideoGravity = .resizeAspect,
        eColor: Color = .accentColor,
        eFontSize: CGFloat = 17.0
    ) {
        settings = Settings {
            SourceName(fileName)
            Ext(ext)
            Gravity(gravity)
            ErrorGroup {
                EColor(eColor)
                EFontSize(eFontSize)
            }
        }
    }
    
    /// Player initializer in a declarative way
    /// - Parameter settings: Set of settings
    public init(_ settings: () -> Settings) {
        self.settings = settings()
    }
    
    // MARK: - API
       
   public var body: some View {
       LoopPlayerMultiPlatform(settings: settings)
           .frame(maxWidth: .infinity, maxHeight: .infinity)
           .id(videoId)
   }
}
