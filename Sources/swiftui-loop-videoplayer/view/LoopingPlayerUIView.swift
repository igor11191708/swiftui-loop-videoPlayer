//
//  LoopingPlayerUIView.swift
//  
//
//  Created by Igor on 10.02.2023.
//

import UIKit
import AVKit

class LoopingPlayerUIView: UIView {

    /// An object that presents the visual contents of a player object
    private let playerLayer = AVPlayerLayer()

    /// An object that loops media content using a queue player
    private var playerLooper: AVPlayerLooper?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
