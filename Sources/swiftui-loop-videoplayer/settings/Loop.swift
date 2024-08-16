//
//  Loop.swift
//
//
//  Created by Igor  on 16.08.24.
//

import Foundation

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct Loop: SettingsConvertible{
    
    // MARK: - Life circle
    
    public init() {}
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.loop]
    }
}
