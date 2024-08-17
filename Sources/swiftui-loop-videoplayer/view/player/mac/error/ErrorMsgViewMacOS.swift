//
//  ErrorMsgViewMacOS.swift
//
//
//  Created by Igor Shelopaev on 06.08.24.
//

import Foundation
import SwiftUI

#if canImport(AppKit)
import AppKit

/// A custom NSTextView for displaying error messages on macOS.
internal class ErrorMsgViewMacOS: NSTextView {
    
    /// Overrides the intrinsic content size to allow flexible width and height.
    override var intrinsicContentSize: NSSize {
        return NSSize(width: NSView.noIntrinsicMetric, height: NSView.noIntrinsicMetric)
    }
    
    /// Called when the view is added to a superview. Sets up the constraints for the view.
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 10),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -10),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    /// Adjusts the layout to center the text vertically within the view.
    override func layout() {
        super.layout()
        
        guard let layoutManager = layoutManager, let textContainer = textContainer else {
            return
        }
        
        let textHeight = layoutManager.usedRect(for: textContainer).size.height
        let containerHeight = bounds.size.height
        let verticalInset = max(0, (containerHeight - textHeight) / 2)
        
        textContainerInset = NSSize(width: 0, height: verticalInset)
    }
}

/// Creates a custom error view for macOS displaying an error message.
/// - Parameters:
///   - error: The error object containing the error description.
///   - color: The color to be used for the error text.
///   - fontSize: The font size to be used for the error text.
/// - Returns: An `NSView` containing the error message text view centered with padding.
internal func errorTpl(_ error: VPErrors, _ color: Color, _ fontSize: CGFloat) -> NSView {
    let textView = ErrorMsgViewMacOS()
    textView.isEditable = false
    textView.isSelectable = false
    textView.drawsBackground = false
    textView.string = error.description
    textView.alignment = .center
    textView.font = NSFont.systemFont(ofSize: fontSize)
    textView.textColor = NSColor(color)
    
    let containerView = NSView()
    containerView.addSubview(textView)
    
    textView.translatesAutoresizingMaskIntoConstraints = false
    
    // Center textView in containerView with padding
    NSLayoutConstraint.activate([
        textView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        textView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        textView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 10),
        textView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -10)
    ])
    
    return containerView
}

#endif
