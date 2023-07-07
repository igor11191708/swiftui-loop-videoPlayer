//
//  Ext.swift
//  
//
//  Created by Igor on 07.07.2023.
//

import Foundation

@available(iOS 14.0, *)
public struct Ext: SettingsConvertible{
        
    /// Video file extension
    let value : String
    
    // MARK: - Life circle
    
    public init(_ value: String) { self.value = value }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.ext(value)]
    }
}
