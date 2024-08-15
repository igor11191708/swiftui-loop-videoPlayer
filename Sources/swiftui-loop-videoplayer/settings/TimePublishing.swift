//
//  TimePublishing.swift
//
//
//  Created by Igor  on 15.08.24.
//

import Foundation
import AVFoundation

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct TimePublishing: SettingsConvertible{
        
    /// Video file extension
    let value : CMTime
    
    // MARK: - Life circle
    
    public init(_ value: CMTime? = nil) { self.value = value ?? CMTime(seconds: 1, preferredTimescale: 600) }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.timePublishing(value)]
    }
}
