//
//  PlayerView.swift
//
//
//  Created by Igor on 10.02.2023.
//

import SwiftUI
import AVKit

/// Player view for running a video in loop
public struct PlayerView: UIViewRepresentable {
    
    /// Name of the video to play
    public let resourceName: String
    
    /// Video extension
    public let extention: String
        
    /// Error message text
    public let errorText : String
    
    /// A structure that defines how a layer displays a player’s visual content within the layer’s bounds
    public let videoGravity: AVLayerVideoGravity

    /// - Parameters:
    ///   - resourceName: Name of the video to play
    ///   - extention: Video extension
    public init(
        resourceName: String,
        extention: String = "mp4",
        errorText : String = "Resource is not found",
        videoGravity: AVLayerVideoGravity = .resizeAspect
    ) {
        self.resourceName = resourceName
        self.extention = extention
        self.errorText = errorText
        self.videoGravity = videoGravity
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }

    /// - Parameter context: Contains details about the current state of the system
    /// - Returns: View
    public func makeUIView(context: Context) -> UIView {
        let name = resourceName
        let ext = extention
        if let view = LoopingPlayerUIView(name, width: ext, gravity: videoGravity){
            return view
    }
       return errorTpl()
    }
        
    /// - Returns: Error view
    private func errorTpl() -> ErrorMsgTextView{
        let textView = ErrorMsgTextView()
        textView.backgroundColor = .clear
        textView.text = errorText
        textView.textAlignment = .center
        return textView
    }
}

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
