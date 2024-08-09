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

/// Cleans up the resources associated with a video player.
/// This function nullifies references to the player, player looper, and observers to facilitate resource deallocation and prevent memory leaks.
/// - Parameters:
///   - player: A reference to the AVQueuePlayer instance. This parameter is passed by reference to allow the function to nullify the external reference.
///   - playerLooper: A reference to the AVPlayerLooper associated with the player. This is also passed by reference to nullify and help in cleaning up.
///   - statusObserver: A reference to an observer watching the player's status changes. Passing by reference allows the function to dispose of it properly.
///   - errorObserver: A reference to an observer monitoring errors from the player. It is managed in the same way as statusObserver to ensure proper cleanup.
func cleanUp(player: inout AVQueuePlayer?, playerLooper: inout AVPlayerLooper?, statusObserver: inout NSKeyValueObservation?, errorObserver: inout NSKeyValueObservation?) {
    // Invalidate and remove references to observers
    statusObserver?.invalidate()
    errorObserver?.invalidate()
    statusObserver = nil
    errorObserver = nil

    // Pause the player and release player-related resources
    player?.pause()
    player = nil
    playerLooper?.disableLooping()
    playerLooper = nil

    // Debugging statement to confirm cleanup in debug builds
    #if DEBUG
    print("Cleaned up AVPlayer and observers.")
    #endif
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

/// Processes an asynchronous video composition request by applying a series of CIFilters.
/// This function ensures each frame processed conforms to specified filter effects.
///
/// - Parameters:
///   - request: An AVAsynchronousCIImageFilteringRequest object representing the current video frame to be processed.
///   - filters: An array of CIFilters to be applied sequentially to the video frame.
///
/// The function starts by clamping the source image to ensure coordinates remain within the image bounds,
/// applies each filter in the provided array, and completes by returning the modified image to the composition request.
internal func handleVideoComposition(request: AVAsynchronousCIImageFilteringRequest, filters: [CIFilter]) {
    // Start with the source image, ensuring it's clamped to avoid any coordinate issues
    var currentImage = request.sourceImage.clampedToExtent()
    
    // Apply each filter in the array to the image
    for filter in filters {
        filter.setValue(currentImage, forKey: kCIInputImageKey)
        if let outputImage = filter.outputImage {
            currentImage = outputImage.clampedToExtent()
        }
    }
    
    // Finish the composition request by outputting the final image
    request.finish(with: currentImage, context: nil)
}
