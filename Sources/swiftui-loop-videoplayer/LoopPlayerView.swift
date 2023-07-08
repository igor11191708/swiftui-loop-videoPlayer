//
//  PlayerView.swift
//
//
//  Created by Igor on 10.02.2023.
//

import SwiftUI
import UIKit
import AVKit

/// Player view for running a video in loop
@available(iOS 14.0, *)
public struct LoopPlayerView: UIViewRepresentable {
        
    /// Set of settings for video the player
    public let settings : Settings
    
    // MARK: - Life circle
    
    /// Player initializer
    /// - Parameters:
    ///   - fileName: Name of the video to play
    ///   - ext: Video extension
    ///   - gravity: A structure that defines how a layer displays a player’s visual content within the layer’s bounds
    ///   - eText: Error message text if file is not found
    ///   - eFontSize: Size of the error text
    public init(
            fileName: String,
            ext: String = "mp4",
            gravity: AVLayerVideoGravity = .resizeAspect,
            eText : String = "Resource is not found",
            eFontSize : CGFloat = 17.0
        ) {
            self.settings = Settings{
                FileName(fileName)
                Ext(ext)
                Gravity(gravity)
                ErrorGroup{
                    EText(eText)
                    EFontSize(eFontSize)
                }
            }
        }
    
    /// Player initializer in a declarative way
    /// - Parameter settings: Set of settings
    public init(_ settings : () -> Settings) {
        self.settings = settings()
    }

    // MARK: - API
    
    /// Inherited from UIViewRepresentable
    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LoopPlayerView>) {
    }

    /// - Parameter context: Contains details about the current state of the system
    /// - Returns: View
    public func makeUIView(context: Context) -> UIView {
        let name = settings.name
        let ext = settings.ext
        let gravity = settings.gravity
        guard let view = LoopingPlayerUIView(name, width: ext, gravity: gravity) else{
            return errorTpl()
    }
       return view
    }
    
    // MARK: - Private
        
    /// - Returns: Error view
    private func errorTpl() -> ErrorMsgTextView{
        let textView = ErrorMsgTextView()
        textView.backgroundColor = .clear
        textView.text = settings.errorText
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: settings.errorFontSize)
        return textView
    }
}


// MARK: - Helpers

/// https://stackoverflow.com/questions/12591192/center-text-vertically-in-a-uitextview
fileprivate class ErrorMsgTextView: UITextView {
    
    override var contentSize: CGSize {
        didSet {
            var top = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            top = max(0, top)
            contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        }
    }
}
