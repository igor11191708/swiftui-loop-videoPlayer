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
    
    /// Name of the video to play
    public let resourceName: String
    
    /// Video extension
    public let extention: String
        
    /// Error message text
    public let errorText : String
    
    /// A structure that defines how a layer displays a player’s visual content within the layer’s bounds
    public let videoGravity: AVLayerVideoGravity
        
    /// Size of the error text Default : 17.0
    public let errorTextSize : CGFloat
    
    /// - Parameters:
    ///   - resourceName: Name of the video to play
    ///   - extention: Video extension
    ///   - errorText: Error message text
    ///   - videoGravity: A structure that defines how a layer displays a player’s visual content within the layer’s bounds
    ///   - errorTextSize: Size of the error text Default : 17.0
    public init(
        resourceName: String,
        extention: String = "mp4",
        errorText : String = "Resource is not found",
        videoGravity: AVLayerVideoGravity = .resizeAspect,
        errorTextSize : CGFloat = 17.0
    ) {
        self.resourceName = resourceName
        self.extention = extention
        self.errorText = errorText
        self.videoGravity = videoGravity
        self.errorTextSize = errorTextSize
    }

    /// Inherited from UIViewRepresentable
    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LoopPlayerView>) {
    }

    /// - Parameter context: Contains details about the current state of the system
    /// - Returns: View
    public func makeUIView(context: Context) -> UIView {
        let name = resourceName
        let ext = extention
        guard let view = LoopingPlayerUIView(name, width: ext, gravity: videoGravity) else{
            return errorTpl()
    }
       return view
    }
    
    // MARK: - Private
        
    /// - Returns: Error view
    private func errorTpl() -> ErrorMsgTextView{
        let textView = ErrorMsgTextView()
        textView.backgroundColor = .clear
        textView.text = errorText
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: errorTextSize)
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
