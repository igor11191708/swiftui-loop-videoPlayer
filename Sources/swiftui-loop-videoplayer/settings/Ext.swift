//
//  Ext.swift
//  
//
//  Created by Igor Shelopaev on 07.07.2023.
//

import Foundation


/// Represents a structure that holds the file extension for a video, conforming to the `SettingsConvertible` protocol.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct Ext: SettingsConvertible{
        
    /// The video file extension value.
    let value: String
    
    // MARK: - Life circle
    
    /// Initializes a new instance of `Ext` with a specific file extension.
    /// - Parameter value: A string representing the file extension of a video.
    public init(_ value: String) { self.value = value }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.ext(value)]
    }
}
