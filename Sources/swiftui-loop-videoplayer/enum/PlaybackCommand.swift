import AVFoundation

/// An enumeration of possible playback commands.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public enum PlaybackCommand: Equatable {
    /// Command to play the video.
    case play
    
    /// Command to pause the video.
    case pause
    
    /// Command to seek to a specific time in the video.
    /// - Parameter time: The target position to seek to in the video, represented in seconds.
    case seek(to: Double)
    
    /// Command to position the video at the beginning.
    case begin
    
    /// Command to position the video at the end.
    case end
    
    /// Command to mute the video.
    case mute
    
    /// Command to unmute the video.
    case unmute
    
    /// Command to adjust the volume of the video playback.
    /// - Parameter volume: A `Float` value between 0.0 (mute) and 1.0 (full volume). Values outside this range will be clamped.
    case volume(Float)
    
    /// Command to set subtitles for the video playback to a specified language or to turn them off.
    /// - Parameter language: The language code for the desired subtitles, pass `nil` to turn subtitles off.
    case subtitles(String?)
    
    /// Command to adjust the playback speed of the video.
    /// - Parameter speed: A `Float` value representing the playback speed. Valid range is typically from 0.5 to 2.0. Negative values will be clamped to 0.0.
    case playbackSpeed(Float)
    
    /// Command to enable looping of the video playback.
    /// Looping is assumed to be enabled by default.
    case loop
    
    /// Command to disable looping of the video playback.
    /// Only affects playback if looping is currently active.
    case unloop

    /// Command to adjust the brightness of the video playback.
    /// - Parameter brightness: A `Float` value typically ranging from -1.0 to 1.0.
    case brightness(Float)
    
    /// Command to adjust the contrast of the video playback.
    /// - Parameter contrast: A `Float` value typically ranging from 0.0 to 4.0.
    case contrast(Float)

    /// Command to apply a specific Core Image filter to the video, with an option to clear existing filters first.
    /// - Parameters:
    ///   - name: Name of the Core Image filter.
    ///   - parameters: Dictionary of parameters to configure the filter.
    ///   - clearExisting: Boolean indicating whether to remove all existing filters before applying this one.
    case filter(name: String, parameters: [String: Any])

    /// Command to remove all applied filters from the video playback.
    case removeAllFilters

    /// Command to select a specific audio track based on language code.
    /// - Parameter languageCode: The language code (e.g., "en" for English) of the desired audio track.
    case audioTrack(languageCode: String)

    public static func == (lhs: PlaybackCommand, rhs: PlaybackCommand) -> Bool {
        switch (lhs, rhs) {
        case (.play, .play), (.pause, .pause), (.begin, .begin), (.end, .end),
             (.mute, .mute), (.unmute, .unmute), (.loop, .loop), (.unloop, .unloop),
             (.removeAllFilters, .removeAllFilters):
            return true

        case (.seek(let lhsTime), .seek(let rhsTime)):
            return lhsTime == rhsTime

        case (.volume(let lhsVolume), .volume(let rhsVolume)):
            return lhsVolume == rhsVolume

        case (.subtitles(let lhsLanguage), .subtitles(let rhsLanguage)):
            return lhsLanguage == rhsLanguage

        case (.playbackSpeed(let lhsSpeed), .playbackSpeed(let rhsSpeed)):
            return lhsSpeed == rhsSpeed

        case (.brightness(let lhsBrightness), .brightness(let rhsBrightness)):
            return lhsBrightness == rhsBrightness

        case (.contrast(let lhsContrast), .contrast(let rhsContrast)):
            return lhsContrast == rhsContrast

        case (.audioTrack(let lhsCode), .audioTrack(let rhsCode)):
            return lhsCode == rhsCode

        case (.filter(let lhsName,let lhsParameters), .filter(let rhsName, let rhsParameters)):
            return lhsName == rhsName && compareParameters(lhsParameters, rhsParameters)
        default:
            return false
        }
    }
}

// Local function to compare two dictionaries
fileprivate func compareParameters(_ lhs: [String: Any], _ rhs: [String: Any]) -> Bool {
    let lhsString = parametersToString(lhs)
    let rhsString = parametersToString(rhs)
    return lhsString == rhsString
}

// Local function to convert parameters dictionary to a sorted string
fileprivate func parametersToString(_ parameters: [String: Any]) -> String {
    let sortedKeys = parameters.keys.sorted()
    return sortedKeys.map { key in
        let value = parameters[key]!
        return "\(key):\(value)"
    }.joined(separator: ",")
}
