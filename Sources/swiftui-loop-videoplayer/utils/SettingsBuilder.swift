//
//  SettingsBuilder.swift
//  
//
//  Created by Igor on 07.07.2023.
//

import SwiftUI

@available(iOS 14.0, *)
@resultBuilder
public struct SettingsBuilder{
    
    /// Build block
    /// - Returns: Empty array
    public static func buildBlock() -> [Setting] { [] }
    
    /// Build block
    /// - Parameter values: Input values
    /// - Returns: Array of settings
    public static func buildBlock(_ values: any SettingsConvertible...) -> [Setting]{
        values.flatMap{ $0.asSettings() }
    }
}
