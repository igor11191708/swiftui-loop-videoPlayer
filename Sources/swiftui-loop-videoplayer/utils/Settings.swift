//
//  Settings.swift
//  
//
//  Created by Igor on 07.07.2023.
//

import Foundation
import AVKit

@available(iOS 14.0, *)
public struct Settings{
    
    /// Name of the video to play
    public let name: String
    
    /// Video extension
    public let ext: String
           
    /// A structure that defines how a layer displays a player’s visual content within the layer’s bounds
    public let gravity: AVLayerVideoGravity
    
    /// Error message text
    public let errorText : String
        
    /// Size of the error text Default : 17.0
    public let errorFontSize : CGFloat
    

    // MARK: - Life circle
    
    public init(@SettingsBuilder builder: () -> [Setting]){
        let settings = builder()
        
        name = settings.fetch(by : "name", defaulted: "")
        
        ext = settings.fetch(by : "ext", defaulted: "mp4")
        
        gravity = settings.fetch(by : "gravity", defaulted: .resizeAspect)
        
        errorText = settings.fetch(by : "errorText", defaulted: "Resource is not found")
        
        errorFontSize = settings.fetch(by : "errorFontSize", defaulted: 17)
    }
}

