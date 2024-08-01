//
//  SettingsConvertible.swift
//  
//
//  Created by Igor on 07.07.2023.
//

import Foundation

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
/// Protocol for building blocks
public protocol SettingsConvertible {
    
    /// Fetch settings
    /// - Returns: Array of settings
    func asSettings() -> [Setting]
}
