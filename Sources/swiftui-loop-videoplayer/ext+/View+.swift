//
//  View+.swift
//
//
//  Created by Igor Shelopaev on 09.08.24.
//

#if canImport(UIKit)
import UIKit

internal extension UIView {
    /// Removes the first subview of the specified type from the view's direct children.
    func removeFirstSubview<T: UIView>(ofType type: T.Type) {
        // Find the first subview of the specified type and remove it.
        if let subview = subviews.first(where: { $0 is T }) {
            subview.removeFromSuperview()
        }
    }
    
    /// Finds the first subview of the specified type within the view's direct children.
    func findFirstSubview<T: UIView>(ofType type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T }.first
    }
}
#endif

#if canImport(AppKit)
import AppKit

internal extension NSView {
    /// Removes the first subview of the specified type from the view's direct children.
    func removeFirstSubview<T: NSView>(ofType type: T.Type) {
        // Find the first subview of the specified type and remove it.
        if let subview = subviews.first(where: { $0 is T }) {
            subview.removeFromSuperview()
        }
    }
    
    /// Finds the first subview of the specified type within the view's direct children.
    func findFirstSubview<T: NSView>(ofType type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T }.first
    }
}

#endif
