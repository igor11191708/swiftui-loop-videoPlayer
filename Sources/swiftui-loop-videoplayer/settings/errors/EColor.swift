//
//  EText.swift
//  
//
//  Created by Igor Shelopaev on 07.07.2023.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct EColor: SettingsConvertible{
        
    /// Error color
    private let value : Color
    
    // MARK: - Life circle

    /// - Parameter value: Error color
    public init(_ value: Color) { self.value = value }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.errorColor(value)]
    }
}
