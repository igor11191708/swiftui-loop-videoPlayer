//
//  fn+.swift
//
//
//  Created by Igor  on 06.08.24.
//

import Foundation
import AVFoundation

/// Retrieves a video asset from either a network URL or a local file specified by name and extension.
///
/// - Parameters:
///   - name: The name of the file or URL.
///   - ext: The file extension for local resources.
/// - Returns: An AVURLAsset initialized with the specified URL or file path.
/// - Throws: VPErrors.sourceNotFound if neither a valid URL nor a local file can be located.
func assetForName(name: String, ext: String) -> AVURLAsset? {
    if let url = URL.validURLFromString(name) {
        return AVURLAsset(url: url)
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

import AVFoundation

/// Seeks to the specified time in the given player if the time is within the video's duration.
/// - Parameters:
///   - player: The `AVQueuePlayer` instance to seek in.
///   - seekTimeInSeconds: The time to seek to, in seconds.
///
/// Note: Errors such as seeking out of the bounds of the video duration are not handled in this function.
/// These issues will be silently ignored. Error handling may be introduced in a future version of the package.
func seekToTime(player: AVQueuePlayer?, seekTimeInSeconds: Double) {
    guard let player = player, let currentItem = player.currentItem else {
        return
    }
    
    let duration = currentItem.duration
    if CMTimeGetSeconds(duration) > 0 {
        let seekTime = CMTime(seconds: seekTimeInSeconds, preferredTimescale: 600)
        if CMTimeCompare(seekTime, duration) <= 0 && CMTimeCompare(seekTime, .zero) >= 0 {
            player.seek(to: seekTime)
        }
    }
}
