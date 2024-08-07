//
//  constraintsFn.swift
//
//
//  Created by Igor  on 06.08.24.
//

import Foundation

#if canImport(AppKit)
import AppKit

/// Activates full-screen constraints for a given view within its container view.
/// This method sets up constraints to make the `view` fill the entire `containerView`.
/// - Parameters:
///   - view: The view for which full-screen constraints will be applied.
///   - containerView: The parent view in which `view` will be constrained to match the full size.
func activateFullScreenConstraints(for view: NSView, in containerView: NSView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        view.topAnchor.constraint(equalTo: containerView.topAnchor),
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
}
#endif

#if canImport(UIKit)
import UIKit

/// Activates full-screen constraints for a view within a container view.
///
/// - Parameters:
///   - view: The view to be constrained.
///   - containerView: The container view to which the constraints are applied.
func activateFullScreenConstraints(for view: UIView, in containerView: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        view.topAnchor.constraint(equalTo: containerView.topAnchor),
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
}
#endif
