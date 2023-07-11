//
//  Settings.swift
//  
//
//  Created by Igor on 07.07.2023.
//

import SwiftUI
import AVKit

@available(iOS 14.0, *)
public struct Settings{
    
    // MARK: - Public properties
    
    /// Name of the video to play
    public let name: String
    
    /// Video extension
    public let ext: String
           
    /// A structure that defines how a layer displays a player’s visual content within the layer’s bounds
    public let gravity: AVLayerVideoGravity
    
    /// Error message text color
    public let errorColor : Color
        
    /// Size of the error text Default : 17.0
    public let errorFontSize : CGFloat
        
    /// Are the params unique
    public var areUnique : Bool {
        unique
    }
    
    // MARK: - Private properties
    
    /// Is settings are unique
    private let unique : Bool

    // MARK: - Life circle
        
    /// - Parameter builder: Block builder
    public init(@SettingsBuilder builder: () -> [Setting]){
        let settings = builder()
        
        unique = check(settings)
        
        name = settings.fetch(by : "name", defaulted: "")
        
        ext = settings.fetch(by : "ext", defaulted: "mp4")
        
        gravity = settings.fetch(by : "gravity", defaulted: .resizeAspect)
        
        errorColor = settings.fetch(by : "errorColor", defaulted: .red)
        
        errorFontSize = settings.fetch(by : "errorFontSize", defaulted: 17)
    }
}

/// Check if unique
/// - Parameter settings: Passed array of settings flatted by block builder
/// - Returns: True - unique False - not
fileprivate func check(_ settings : [Setting]) -> Bool{
    let cases : [String] = settings.map{ $0.caseName }
    let set = Set(cases)
    return cases.count == set.count    
}

