//
//  CustomView.swift
//
//
//  Created by Igor  on 06.08.24.
//

import Foundation

internal protocol CustomView {
    /// A collection of subviews contained within the view.
    var subviews: [Self] { get }

    /// Removes a subview from the view.
    func removeFromSuperview()

    /// Adds a subview to the view.
    func addSubview(_ subview: Self)
}
