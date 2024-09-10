//
//  ErrorGroup.swift
//  
//
//  Created by Igor Shelopaev on 07.07.2023.
//

import Foundation


/// Represents a grouping structure for error-related settings, conforming to the `SettingsConvertible` protocol.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct ErrorGroup: SettingsConvertible{
        
    /// Errors settings
    private let settings : [Setting]
    
    // MARK: - Life circle
    
    /// Initializes a new instance of `ErrorGroup` with a settings builder.
    /// - Parameter builder: A closure that constructs and returns an array of `Setting` instances.
    public init(@SettingsBuilder builder: () -> [Setting] ) {
        settings = builder()
    }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        settings
    }
}
