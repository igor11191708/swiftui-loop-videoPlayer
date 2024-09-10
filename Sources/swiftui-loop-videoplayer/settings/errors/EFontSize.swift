//
//  EFontSize.swift
//  
//
//  Created by Igor Shelopaev on 07.07.2023.
//

import Foundation
import CoreGraphics

/// Represents a structure for defining error font sizes that can be converted into settings.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct EFontSize: SettingsConvertible{
        
    /// The font size value.
    private let value : CGFloat
    
    // MARK: - Life circle
    
    /// Initializes a new instance of `EFontSize` with a specific font size.
    /// - Parameter value: The font size as a `CGFloat`.
    public init(_ value: CGFloat) { self.value = value }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.errorFontSize(value)]
    }
}
