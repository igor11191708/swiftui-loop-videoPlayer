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
    @Binding public var settings: VideoSettings
    
    /// Binding to a playback command that controls playback actions
    @Binding public var command: PlaybackCommand
    
    private var videoId : String{
        [settings.name, settings.ext].joined(separator: ".")
    }
    
    // MARK: - Life cycle
    
    /// Player initializer
    /// - Parameters:
    ///   - fileName: Name of the video to play
    ///   - ext: Video extension
    ///   - gravity: A structure that defines how a layer displays a player’s visual content within the layer’s bounds
    ///   - eColor: Color of the error message text if the file is not found
    ///   - eFontSize: Size of the error text
    ///   - command: A binding to control playback actions
    public init(
        fileName: String,
        ext: String = "mp4",
        gravity: AVLayerVideoGravity = .resizeAspect,
        eColor: Color = .accentColor,
        eFontSize: CGFloat = 17.0,
        command : Binding<PlaybackCommand> = .constant(.play)
    ) {
        self._command = command
        
        _settings = .constant(
            VideoSettings {
                SourceName(fileName)
                Ext(ext)
                Gravity(gravity)
                ErrorGroup {
                    EColor(eColor)
                    EFontSize(eFontSize)
                }
            }
        )
    }
    
    /// Player initializer in a declarative way
    /// - Parameters:
    ///   - settings: Set of settings
    ///   - command: A binding to control playback actions
    public init(
        _ settings: () -> VideoSettings,
        command: Binding<PlaybackCommand> = .constant(.play)
    ) {

        self._command = command
        _settings = .constant(settings())
    }
    
    /// Player initializer in a declarative way
    /// - Parameters:
    ///   - settings: A binding to the set of settings for the video player
    ///   - command: A binding to control playback actions
    public init(
        settings: Binding<VideoSettings>,
        command: Binding<PlaybackCommand> = .constant(.play)
    ) {
        self._settings = settings
        self._command = command
    }
    
    // MARK: - API
       
   public var body: some View {
       LoopPlayerMultiPlatform(settings: $settings, command: $command)
           .frame(maxWidth: .infinity, maxHeight: .infinity)
   }
}
