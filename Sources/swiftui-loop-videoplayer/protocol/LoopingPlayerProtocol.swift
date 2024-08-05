//
//  LoopingPlayerProtocol.swift
//
//
//  Created by Igor  on 05.08.24.
//

import AVFoundation
import Foundation

/// A protocol defining the requirements for a looping video player.
///
/// Conforming types are expected to manage a video player that can loop content continuously,
/// handle errors, and notify a delegate of important events.
@available(iOS 14, macOS 11, tvOS 14, *)
@MainActor
protocol LoopingPlayerProtocol: AnyObject {
    /// The looper responsible for continuous video playback.
    var playerLooper: AVPlayerLooper? { get set }

    /// The queue player that plays the video items.
    var player: AVQueuePlayer? { get set }

    /// The delegate to be notified about errors encountered by the player.
    var delegate: PlayerErrorDelegate? { get set }
    
    var statusObserver: NSKeyValueObservation? { get set }
    var errorObserver: NSKeyValueObservation? { get set }

    /// Sets up the necessary observers on the AVPlayerItem and AVQueuePlayer to monitor changes and errors.
    ///
    /// - Parameters:
    ///   - item: The AVPlayerItem to observe for status changes.
    ///   - player: The AVQueuePlayer to observe for errors.
    func setupObservers(for item: AVPlayerItem, player: AVQueuePlayer)

    /// Responds to changes in the playback status of an AVPlayerItem.
    ///
    /// - Parameter item: The AVPlayerItem whose status changed.
    func handlePlayerItemStatusChange(_ item: AVPlayerItem)

    /// Responds to errors reported by the AVQueuePlayer.
    ///
    /// - Parameter player: The AVQueuePlayer that encountered an error.
    func handlePlayerError(_ player: AVPlayer)
    
    
    /// Configures the provided AVQueuePlayer with specific properties for video playback.
    /// - Parameters:
    ///   - player: The AVQueuePlayer to be configured.
    ///   - gravity: The AVLayerVideoGravity determining how the video content should be scaled or fit within the player layer.
    func configurePlayer(_ player: AVQueuePlayer, gravity: AVLayerVideoGravity)
}

extension LoopingPlayerProtocol {
    
    
    /// Sets up and initializes the player components based on specified media files and layout properties.
    ///
    /// - Parameters:
    ///   - name: The name of the media file to load.
    ///   - ext: The file extension of the media file.
    ///   - gravity: The AVLayerVideoGravity to apply to the video, which defines how the video should be scaled or fit within its player layer.
    func setupPlayerComponents(asset: AVURLAsset, gravity: AVLayerVideoGravity) {

      //  do{
          //  let asset = try assetForName(name: name, ext: ext)
            
            let item = AVPlayerItem(asset: asset)
            
            let player = AVQueuePlayer(items: [item])
            self.player = player
            
            configurePlayer(player, gravity: gravity)
            
            setupObservers(for: item, player: player)
//        }catch{
//            delegate?.didReceiveError(.sourceNotFound(error.localizedDescription))
//       }
    }
    
    /// Sets up observers on the player item and the player to track their status and error states.
    ///
    /// - Parameters:
    ///   - item: The player item to observe.
    ///   - player: The player to observe.
    func setupObservers(for item: AVPlayerItem, player: AVQueuePlayer) {
        statusObserver = item.observe(\.status, options: [.new]) { [weak self] item, _ in
            self?.handlePlayerItemStatusChange(item)
        }
        
        errorObserver = player.observe(\.error, options: [.new]) { [weak self] player, _ in
            self?.handlePlayerError(player)
        }
    }

    /// Responds to changes in the status of an AVPlayerItem.
    ///
    /// This method checks if the status of the AVPlayerItem indicates a failure.
    /// If a failure occurs, it notifies the delegate about the error.
    /// - Parameter item: The AVPlayerItem whose status has changed to be evaluated.
    func handlePlayerItemStatusChange(_ item: AVPlayerItem) {
        guard item.status == .failed, let error = item.error else { return }
        delegate?.didReceiveError(.remoteVideoError(error))
    }

    /// Responds to errors reported by the AVPlayer.
    ///
    /// If an error is present, this method notifies the delegate of the encountered error,
    /// encapsulated within a `remoteVideoError`.
    /// - Parameter player: The AVPlayer that encountered an error to be evaluated.
    func handlePlayerError(_ player: AVPlayer) {
        guard let error = player.error else { return }
        delegate?.didReceiveError(.remoteVideoError(error))
    }
}

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


