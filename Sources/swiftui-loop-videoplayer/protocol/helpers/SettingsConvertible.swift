//
//  SettingsConvertible.swift
//  
//
//  Created by Igor Shelopaev on 07.07.2023.
//

import Foundation


/// Protocol for building blocks
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public protocol SettingsConvertible {
    
    /// Fetch settings
    /// - Returns: Array of settings
    func asSettings() -> [Setting]
}

