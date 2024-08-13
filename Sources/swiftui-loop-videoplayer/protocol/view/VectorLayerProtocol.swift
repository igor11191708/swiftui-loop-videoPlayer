//
//  VectorLayerProtocol.swift
//
//
//  Created by Igor Shelopaev on 13.08.24.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
import QuartzCore

@available(iOS 14, macOS 11, tvOS 14, *)
@MainActor
public protocol LayerMakerProtocol{
    
    var compositeLayer : CALayer{ get }
    
    var frame: CGRect { get set }
    
    var bounds : CGRect { get set }
    
    func addVectorLayer(builder : any ShapeLayerBuilderProtocol, clear: Bool)
    
    func removeAllVectors()
}

extension LayerMakerProtocol{
    
    @MainActor
    /// Sets a vector graphic operation on the video player.
    /// - Parameters:
    ///   - builder: An instance conforming to `ShapeLayerBuilderProtocol` to provide the shape layer.
    ///   - clear: A Boolean value indicating whether to clear existing vector graphics before applying the new one. Defaults to `false`.
    func addVectorLayer(builder : any ShapeLayerBuilderProtocol, clear: Bool){
        if clear{ removeAllVectors() }
        let layer = builder.build(with: (frame, bounds))
        compositeLayer.addSublayer(layer)
    }
    
    @MainActor
    /// Clears all vector graphics from the video player.
    func removeAllVectors(){
            compositeLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
}
