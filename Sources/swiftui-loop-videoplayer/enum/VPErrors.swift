//
//  VPErrors.swift
//
//
//  Created by Igor on 09.07.2023.
//

import Foundation

/// An enumeration of possible errors that can occur in the video player.
enum VPErrors: Error, CustomStringConvertible {
    
    /// Error case for when a file is not found.
    /// - Parameter name: The name of the file that was not found.
    case fileNotFound(String)
    
    /// Error case for when settings are not unique.
    case settingsNotUnique
    
    /// A description of the error, suitable for display.
    var description: String {
        switch self {
            /// Returns a description indicating that the specified file was not found.
            /// - Parameter name: The name of the file that was not found.
            case .fileNotFound(let name): return "File not found: \(name)"
            
            /// Returns a description indicating that the settings are not unique.
            case .settingsNotUnique: return "Settings are not unique"
        }
    }
}
