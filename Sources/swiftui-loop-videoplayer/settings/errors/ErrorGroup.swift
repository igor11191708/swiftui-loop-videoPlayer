//
//  ErrorGroup.swift
//  
//
//  Created by Igor on 07.07.2023.
//

import Foundation

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct ErrorGroup: SettingsConvertible{
        
    /// Errors settings
    private let settings : [Setting]
    
    // MARK: - Life circle
    
    public init(@SettingsBuilder builder: () -> [Setting] ) {
        settings = builder()
    }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        settings
    }
}
