//
//  fn+.swift
//
//
//  Created by Igor Shelopaev on 06.08.24.
//

import Foundation
import AVFoundation
import CoreImage

/// Retrieves an `AVURLAsset` based on specified video settings.
/// - Parameter settings: The `VideoSettings` object containing details like name and extension of the video.
/// - Returns: An optional `AVURLAsset`. Returns `nil` if the video cannot be located either by URL or in the app bundle.
func assetFor(_ settings: VideoSettings) -> AVURLAsset? {
    let name = settings.name
    let ext = settings.ext
    
    // Attempt to create a URL directly from the provided video name string
    if let url = URL.validURLFromString(name) {
        return AVURLAsset(url: url)
    // If direct URL creation fails, attempt to locate the video in the main bundle using the name and extension
    } else if let fileUrl = Bundle.main.url(forResource: name, withExtension: extractExtension(from: name) ?? ext) {
        return AVURLAsset(url: fileUrl)
    }
    
    return nil
}

/// Checks whether a given filename contains an extension and returns the extension if it exists.
///
/// - Parameter name: The filename to check.
/// - Returns: An optional string containing the extension if it exists, otherwise nil.
fileprivate func extractExtension(from name: String) -> String? {
    let pattern = "^.*\\.([^\\s]+)$"
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: name.utf16.count)
    
    if let match = regex?.firstMatch(in: name, options: [], range: range) {
        if let extensionRange = Range(match.range(at: 1), in: name) {
            return String(name[extensionRange])
        }
    }
    return nil
}

/// Detects and returns the appropriate error based on settings and asset.
/// - Parameters:
///   - settings: The settings for the video player.
///   - asset: The asset for the video player.
/// - Returns: The detected error or nil if no error.
func detectError(settings: VideoSettings, asset: AVURLAsset?) -> VPErrors? {
    if !settings.areUnique {
        return .settingsNotUnique
    } else if asset == nil {
        return .sourceNotFound(settings.name)
    } else {
        return nil
    }
}

/// Combines an array of CIFilters with additional brightness and contrast adjustments.
///
/// This function appends brightness and contrast adjustments as CIFilters to the existing array of filters.
///
/// - Parameters:
///   - filters: An array of CIFilter objects to which the brightness and contrast filters will be added.
///   - brightness: A Float value representing the brightness adjustment to apply.
///   - contrast: A Float value representing the contrast adjustment to apply.
///
/// - Returns: An array of CIFilter objects, including the original filters and the added brightness and contrast adjustments.
internal func combineFilters(_ filters: [CIFilter],_ brightness:  Float,_ contrast: Float) -> [CIFilter] {
    var allFilters = filters
    if let filter = CIFilter(name: "CIColorControls", parameters: [kCIInputBrightnessKey: brightness]) {
        allFilters.append(filter)
    }
    if let filter = CIFilter(name: "CIColorControls", parameters: [kCIInputContrastKey: contrast]) {
        allFilters.append(filter)
    }
    return allFilters
}

