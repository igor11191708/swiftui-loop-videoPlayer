//
//  SettingsBuilder.swift
//  
//
//  Created by Igor Shelopaev on 07.07.2023.
//

import SwiftUI
import AVKit

// Result builder to construct an array of 'Setting' objects.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
@resultBuilder
public struct SettingsBuilder {
    
    /// Combines a single expression into an array of settings.
    /// - Parameter expression: A type conforming to `SettingsConvertible`.
    /// - Returns: An array of settings derived from the expression.
    public static func buildExpression(_ expression: SettingsConvertible) -> [Setting] {
        return expression.asSettings()
    }
    
    /// Combines an optional expression into an array of settings.
    /// - Parameter component: An optional type conforming to `SettingsConvertible`.
    /// - Returns: An array of settings derived from the expression if it's non-nil, otherwise an empty array.
    public static func buildOptional(_ component: [Setting]?) -> [Setting] {
        return component ?? []
    }
    
    /// Combines multiple expressions into a single array of settings.
    /// - Parameter components: An array of arrays of settings.
    /// - Returns: A flattened array of settings.
    public static func buildBlock(_ components: [Setting]...) -> [Setting] {
        return components.flatMap { $0 }
    }
}
