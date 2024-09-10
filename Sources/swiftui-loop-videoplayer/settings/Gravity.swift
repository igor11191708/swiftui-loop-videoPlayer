//
//  Gravity.swift
//  
//
//  Created by Igor Shelopaev on 07.07.2023.
//

import Foundation
import AVKit

/// Represents video layout options as gravity settings, conforming to `SettingsConvertible`.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct Gravity : SettingsConvertible{
        
    /// Holds the specific AVLayerVideoGravity setting defining how video content should align within its layer.
    private let value : AVLayerVideoGravity
    
    // MARK: - Life circle
    
    /// Initializes a new Gravity instance with a specified video gravity.
    /// - Parameter value: The `AVLayerVideoGravity` value to set.
    public init(_ value: AVLayerVideoGravity) { self.value = value }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.gravity(value)]
    }
}
