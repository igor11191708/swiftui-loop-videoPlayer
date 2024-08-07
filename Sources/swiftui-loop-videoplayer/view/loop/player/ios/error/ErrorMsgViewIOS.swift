//
//  ErrorMsgViewIOS.swift
//
//
//  Created by Igor  on 06.08.24.
//

import SwiftUI
import Foundation

#if os(iOS) || os(tvOS)
import UIKit

internal class ErrorMsgViewIOS: UITextView {
    
    /// Adjusts the top content inset to vertically center the text.
    override var contentSize: CGSize {
        didSet {
            var top = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            top = max(0, top)
            contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        }
    }
}

/// Creates an error message view for iOS with the specified error, color, and font size.
///
/// - Parameters:
///   - error: The error to display.
///   - color: The color of the error text.
///   - fontSize: The font size of the error text.
/// - Returns: A configured UIView displaying the error message.
@MainActor
internal func errorTpl(_ error: VPErrors, _ color: Color, _ fontSize: CGFloat) -> UIView {
    let textView = ErrorMsgViewIOS()
    textView.backgroundColor = .clear
    textView.text = error.description
    textView.textAlignment = .center
    textView.font = UIFont.systemFont(ofSize: fontSize)
    textView.textColor = UIColor(color)
    return textView
}

#endif
