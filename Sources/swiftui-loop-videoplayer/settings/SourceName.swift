//
//  FileName.swift
//  
//
//  Created by Igor Shelopaev on 07.07.2023.
//

import Foundation


/// Represents a structure that holds the name of a video source, conforming to `SettingsConvertible`.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct SourceName : SettingsConvertible{
          
    /// Video file name
    let value : String
    
    // MARK: - Life circle
    
    /// Initializes a new instance with a specific video file name.
    /// - Parameter value: The string representing the video file name.
    public init(_ value: String) { self.value = value }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.name(value)]
    }
}
