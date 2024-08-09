import AVFoundation

/// An enumeration of possible playback commands.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public enum PlaybackCommand: Equatable {
    /// Command to play the video.
    case play
    
    /// Command to pause the video.
    case pause
    
    /// Command to seek to a specific time in the video.
    /// - Parameter time: The CMTime representing the target position to seek to in the video.
    case seek(to: Double)
    
    /// Command to position the video at the beginning.
    case begin
    
    /// Command to position the video at the end.
    case end
    
    /// Command to mute the video.
    case mute
    
    /// Command to unmute the video.
    case unmute
    
    /// Command to set the volume of the video playback.
    /// - Parameter volume: A `Float` value between 0.0 (mute) and 1.0 (full volume).
    case volume(Float)
    
    /// Command to set subtitles for the video playback to a specified language or to turn them off.
    /// - Parameter language: The language code (e.g., "en" for English) for the desired subtitles.
    ///                       Pass `nil` to turn off subtitles.
    case subtitles(String?)
    
    /// Command to set the playback speed of the video playback.
    /// - Parameter speed: A `Float` value representing the playback speed (e.g., 1.0 for normal speed, 0.5 for half speed, 2.0 for double speed).
    case playbackSpeed(Float)
    
    /// Command to enable looping of the video playback.
    case loop
    
    /// Command to disable looping of the video playback.
    case unloop

    public static func == (lhs: PlaybackCommand, rhs: PlaybackCommand) -> Bool {
        switch (lhs, rhs) {
        case (.play, .play),
             (.pause, .pause),
             (.begin, .begin),
             (.end, .end),
             (.mute, .mute),
             (.unmute, .unmute),
             (.loop, .loop),
             (.unloop, .unloop):
            return true
        case (.seek(let lhsTime), .seek(let rhsTime)):
            return lhsTime == rhsTime
        case (.volume(let lhsVolume), .volume(let rhsVolume)):
            return lhsVolume == rhsVolume
        case (.subtitles(let lhsLanguage), .subtitles(let rhsLanguage)):
            return lhsLanguage == rhsLanguage
        case (.playbackSpeed(let lhsSpeed), .playbackSpeed(let rhsSpeed)):
            return lhsSpeed == rhsSpeed
        default:
            return false
        }
    }
}
