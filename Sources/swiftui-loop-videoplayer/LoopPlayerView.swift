//
//  PlayerView.swift
//
//
//  Created by Igor on 10.02.2023.
//

import SwiftUI
import Combine
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
    
    /// The current playback time, represented as a Double.
    @State private var currentTime: Double = 0.0
    
    /// A publisher that emits the current time as a Double value.
    @State var timePublisher = PassthroughSubject<Double, Never>()
    
    private var videoId : String{
        [settings.name, settings.ext].joined(separator: ".")
    }
    
    // MARK: - Life cycle
    
    /// Player initializer
    /// - Parameters:
    ///   - fileName: The name of the video file.
    ///   - ext: The file extension, with a default value of "mp4".
    ///   - gravity: The video gravity setting, with a default value of `.resizeAspect`.
    ///   - timePublishing: An optional `CMTime` value for time publishing, with a default value of 1 second.
    ///   - eColor: The color to be used, with a default value of `.accentColor`.
    ///   - eFontSize: The font size to be used, with a default value of 17.0.
    ///   - command: A binding to the playback command, with a default value of `.play`.
    public init(
        fileName: String,
        ext: String = "mp4",
        gravity: AVLayerVideoGravity = .resizeAspect,
        timePublishing : CMTime? = CMTime(seconds: 1, preferredTimescale: 600),
        eColor: Color = .accentColor,
        eFontSize: CGFloat = 17.0,
        command : Binding<PlaybackCommand> = .constant(.play)
    ) {
        self._command = command

        func description(@SettingsBuilder content: () -> [Setting]) -> [Setting] {
          return content()
        }
        
        let settings: VideoSettings = VideoSettings {
            SourceName(fileName)
            Ext(ext)
            Gravity(gravity)
            if let timePublishing{
                timePublishing
           }
            ErrorGroup {
                EColor(eColor)
                EFontSize(eFontSize)
            }
        }
        
        _settings = .constant(settings)
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
       LoopPlayerMultiPlatform(settings: $settings, command: $command, timePublisher: timePublisher)
           .frame(maxWidth: .infinity, maxHeight: .infinity)
           .onReceive(timePublisher, perform: { time in
               currentTime = time
           })
           .preference(key: CurrentTimePreferenceKey.self, value: currentTime)
   }
}
