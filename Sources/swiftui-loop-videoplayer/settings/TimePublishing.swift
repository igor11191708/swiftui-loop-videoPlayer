//
//  TimePublishing.swift
//
//
//  Created by Igor Shelopaev on 15.08.24.
//

import Foundation
import AVFoundation

/// Represents a structure for setting the publishing time of a video, conforming to `SettingsConvertible`.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct TimePublishing: SettingsConvertible{
        
    /// Holds the time value associated with the video publishing time, using `CMTime`.
    let value : CMTime
    
    // MARK: - Life circle
    
    /// Initializes a new instance of `TimePublishing` with an optional `CMTime` value, defaulting to 1 second at a timescale of 600 if not provided.
    /// - Parameter value: Optional `CMTime` value to set as the default time.
    public init(_ value: CMTime? = nil) { self.value = value ?? CMTime(seconds: 1, preferredTimescale: 600) }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.timePublishing(value)]
    }
}
