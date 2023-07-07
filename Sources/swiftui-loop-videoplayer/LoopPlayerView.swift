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
    
    public init(fileName : String){
        self.settings = Settings{
            FileName(fileName)
        }
    }
    
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
