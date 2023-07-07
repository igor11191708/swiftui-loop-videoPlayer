//
//  Gravity.swift
//  
//
//  Created by Igor on 07.07.2023.
//

import Foundation
import AVKit

@available(iOS 14.0, *)
public struct Gravity : SettingsConvertible{
        
    /// Video gravity spec
    private let value : AVLayerVideoGravity
    
    // MARK: - Life circle
    
    public init(_ value: AVLayerVideoGravity) { self.value = value }
    
    /// Fetch settings
    @_spi(Private)
    public func asSettings() -> [Setting] {
        [.gravity(value)]
    }
}
