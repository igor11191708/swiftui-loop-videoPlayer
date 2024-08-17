//
//  FileName.swift
//  
//
//  Created by Igor Shelopaev on 07.07.2023.
//

import Foundation

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct SourceName : SettingsConvertible{
          
    /// Video file name
    let value : String
    
    // MARK: - Life circle
    
    public init(_ value: String) { self.value = value }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.name(value)]
    }
    
}
