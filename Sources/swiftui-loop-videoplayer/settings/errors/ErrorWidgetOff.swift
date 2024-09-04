//
//  ErrorWidgetOff.swift
//
//
//  Created by Igor  on 04.09.24.
//

import Foundation

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct ErrorWidgetOff: SettingsConvertible{
    
    // MARK: - Life circle
    
    public init() {}
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.errorWidgetOff]
    }
}
