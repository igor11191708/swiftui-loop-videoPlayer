//
//  LoopingPlayerUIView.swift
//
//
//  Created by Igor on 10.02.2023.
//

import AVKit


#if canImport(UIKit) && os(tvOS)
import UIKit

@available(iOS 14.0, *)
class LoopingPlayerUIView: UIView {

    /// An object that presents the visual contents of a player object
    private let playerLayer = AVPlayerLayer()

    /// An object that loops media content using a queue player
    private var playerLooper: AVPlayerLooper?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Parameters:
    ///   - name: Name of the video to play
    ///   - ext: Video extension
    ///   - gravity: A structure that defines how a layer displays a player’s visual content within the layer’s bounds
    init?(_ name: String, width ext: String, gravity: AVLayerVideoGravity) {

        /// Load the resource
        guard let fileUrl = Bundle.main.url(forResource: name, withExtension: ext) else{
            return nil
        }
        
        let asset = AVAsset(url: fileUrl)
        
        let item = AVPlayerItem(asset: asset)

        /// Setup the player
        let player = AVQueuePlayer()
        player.isMuted = true
        playerLayer.player = player
        playerLayer.videoGravity = gravity
        playerLayer.backgroundColor = UIColor.clear.cgColor

        super.init(frame: CGRect.zero)

        /// Create a new player looper with the queue player and template item
        playerLooper = AVPlayerLooper(player: player, templateItem: item)

        /// Start the movie
        player.play()

        layer.addSublayer(playerLayer)
    }
    
    /// override point. called by layoutIfNeeded automatically. As of iOS 6.0, when constraints-based layout is used the base implementation applies the constraints-based layout, otherwise it does nothing.
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

#elseif canImport(Cocoa)
import Cocoa

@available(macOS 11.0, *)
class LoopingPlayerNSView: NSView {

    /// An object that presents the visual contents of a player object
    private let playerLayer = AVPlayerLayer()

    /// An object that loops media content using a queue player
    private var playerLooper: AVPlayerLooper?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Parameters:
    ///   - name: Name of the video to play
    ///   - ext: Video extension
    ///   - gravity: A structure that defines how a layer displays a player’s visual content within the layer’s bounds
    init?(_ name: String, width ext: String, gravity: AVLayerVideoGravity) {

        /// Load the resource
        guard let fileUrl = Bundle.main.url(forResource: name, withExtension: ext) else{
            return nil
        }
        
        let asset = AVAsset(url: fileUrl)
        
        let item = AVPlayerItem(asset: asset)

        /// Setup the player
        let player = AVQueuePlayer()
        player.isMuted = true
        playerLayer.player = player
        playerLayer.videoGravity = gravity
        playerLayer.backgroundColor = NSColor.clear.cgColor

        super.init(frame: .zero)

        /// Create a new player looper with the queue player and template item
        playerLooper = AVPlayerLooper(player: player, templateItem: item)

        /// Start the movie
        player.play()

        layer = CALayer()
        layer?.addSublayer(playerLayer)
        wantsLayer = true
    }
    
    /// Called automatically when the view's bounds change
    override func layout() {
        super.layout()
        playerLayer.frame = bounds
    }
}
#endif
