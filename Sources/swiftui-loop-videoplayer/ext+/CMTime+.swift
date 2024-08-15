//
//  CMTime+.swift
//
//
//  Created by Igor  on 15.08.24.
//

#if canImport(AVKit)
import AVKit
#endif

extension CMTime : SettingsConvertible{
    public func asSettings() -> [Setting] {
        [.timePublishing(self)]
    }
}
