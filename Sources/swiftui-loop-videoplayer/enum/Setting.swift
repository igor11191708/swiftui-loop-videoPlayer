//
//  Setting.swift
//  
//
//  Created by Igor on 07.07.2023.
//

import Foundation
import AVKit
import SwiftUI

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

    /// Size of the error text
    case errorFontSize(CGFloat)
    
    /// Color of the error text
    case errorColor(Color)
    
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
