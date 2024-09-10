//
//  EText.swift
//  
//
//  Created by Igor Shelopaev on 07.07.2023.
//

import SwiftUI

/// Defines a structure for error text colors that can be converted to settings.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct EColor: SettingsConvertible{
        
    /// The color value used for errors.
    private let value: Color
    
    // MARK: - Life cycle
    
    /// Initializes a new instance of `EColor` with a specified color for errors.
    /// - Parameter value: The error color.
    public init(_ value: Color) { self.value = value }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.errorColor(value)]
    }
}
