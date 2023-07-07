//
//  Setting.swift
//  
//
//  Created by Igor on 07.07.2023.
//

import Foundation
import AVKit

/// Settings for loop video player
@available(iOS 14.0, *)
public enum Setting: Equatable{
    
    /// File name
    case name(String)

    /// File extension
    case ext(String)

    /// Video gravity
    case gravity(AVLayerVideoGravity = .resizeAspect)

    /// Error text is resource is not found
    case errorText(String)

    /// Size of the error textкуадусешщт аштв
    case errorFontSize(CGFloat)
    
    /// Case name
    var caseName: String {
        Mirror(reflecting: self).children.first?.label ?? "\(self)"
    }
    
    /// Associated value
    var associatedValue: Any? {
            
        guard let firstChild = Mirror(reflecting: self).children.first else {
            return nil
        }
        
        return firstChild.value
    }
}

@available(iOS 14.0, *)
extension Array where Element == Setting{
    
    /// Find first setting by case name
    /// - Parameter name: Case name
    /// - Returns: Setting
    private func first(_ name : String) -> Setting?{
        self.first(where: { $0.caseName == name })
    }
    
    
    /// Fetch associated value
    /// - Parameters:
    ///   - name: Case name
    ///   - defaulted: Default value
    /// - Returns: Associated value
    func fetch<T>(by name : String, defaulted : T) -> T{
        guard let value = first(name)?.associatedValue as? T else {
            return defaulted
        }
        
        return value
    }
}



