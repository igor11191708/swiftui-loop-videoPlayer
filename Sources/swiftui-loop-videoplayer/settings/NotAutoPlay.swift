//
//  NotAutoPlay.swift
//
//
//  Created by Igor  on 10.09.24.
//

import Foundation


/// Represents a setting to disable automatic playback, conforming to `SettingsConvertible`.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct NotAutoPlay: SettingsConvertible{
    
    // MARK: - Life circle
    
    /// Initializes a new instance
    public init() {}
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.notAutoPlay]
    }
}
