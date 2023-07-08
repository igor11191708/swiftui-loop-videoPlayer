//
//  EFontSize.swift
//  
//
//  Created by Igor on 07.07.2023.
//

import Foundation
import CoreGraphics

@available(iOS 14.0, *)
public struct EFontSize: SettingsConvertible{
        
    /// Font size value
    private let value : CGFloat
    
    // MARK: - Life circle
    
    public init(_ value: CGFloat) { self.value = value }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.errorFontSize(value)]
    }
}
