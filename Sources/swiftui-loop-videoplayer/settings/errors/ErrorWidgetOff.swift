//
//  ErrorWidgetOff.swift
//
//
//  Created by Igor Shelopaev on 04.09.24.
//

import Foundation


/// Represents a structure to hide the error widget, conforming to the `SettingsConvertible` protocol.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct ErrorWidgetOff: SettingsConvertible{
    
    // MARK: - Life circle
    
    /// Initializes a new instance
    public init() {}
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.errorWidgetOff]
    }
}
