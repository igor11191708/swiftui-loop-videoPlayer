//
//  Settings.swift
//  
//
//  Created by Igor Shelopaev on 07.07.2023.
//

import SwiftUI
import AVKit

@available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
public struct VideoSettings: Equatable{
    
    // MARK: - Public properties
    
    /// Name of the video to play
    public let name: String
    
    /// Video extension
    public let ext: String
    
    /// Loop video
    public let loop: Bool
    
    /// Mute video
    public let mute: Bool
    
    /// A CMTime value representing the interval at which the player's current time should be published.
    /// If set, the player will publish periodic time updates based on this interval.
    public let timePublishing: CMTime?
           
    /// A structure that defines how a layer displays a player’s visual content within the layer’s bounds
    public let gravity: AVLayerVideoGravity
    
    /// Error message text color
    public let errorColor : Color
        
    /// Size of the error text Default : 17.0
    public let errorFontSize : CGFloat
    
    /// Do not show inner error showcase component
    public let errorWidgetOff: Bool
        
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
        
        timePublishing = settings.fetch(by : "timePublishing", defaulted: nil)
        
        loop = settings.contains(.loop)
        
        mute = settings.contains(.mute)
        
        errorWidgetOff = settings.contains(.errorWidgetOff)
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

