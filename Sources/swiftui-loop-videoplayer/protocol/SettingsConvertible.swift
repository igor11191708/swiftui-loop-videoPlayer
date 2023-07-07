//
//  SettingsConvertible.swift
//  
//
//  Created by Igor on 07.07.2023.
//

import Foundation

@available(iOS 14.0, *)
/// Protocol for building blocks
public protocol SettingsConvertible {
    
    /// Fetch settings
    /// - Returns: Array of settings
    func asSettings() -> [Setting]
}
