//
//  Mute.swift
//
//
//  Created by Igor Shelopaev on 10.09.24.
//

import Foundation

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct Mute: SettingsConvertible{
    
    // MARK: - Life circle
    
    public init() {}
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.mute]
    }
}
