//
//  CMTime+.swift
//
//
//  Created by Igor Shelopaev on 15.08.24.
//

#if canImport(AVKit)
import AVKit
#endif

/// Extends `CMTime` to conform to the `SettingsConvertible` protocol.
extension CMTime : SettingsConvertible {
    
    /// Converts the `CMTime` instance into a settings array containing a time publishing setting.
    /// - Returns: An array of `Setting` with the `timePublishing` case initialized with this `CMTime` instance.
    public func asSettings() -> [Setting] {
        [.timePublishing(self)]
    }
}
