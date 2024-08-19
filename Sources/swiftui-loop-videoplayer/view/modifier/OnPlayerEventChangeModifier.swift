//
//  OnPlayerEventChangeModifier.swift
//
//
//  Created by Igor Shelopaev on 15.08.24.
//

import SwiftUI

/// Defines a custom `PreferenceKey` for handling player events within SwiftUI views.
internal struct PlayerEventPreferenceKey: PreferenceKey {
    /// The default value of player events, initialized as an empty array.
    public static var defaultValue: [PlayerEvent] = []
    
    /// Aggregates values from the view hierarchy when child views provide values.
    public static func reduce(value: inout [PlayerEvent], nextValue: () -> [PlayerEvent]) {
        value = nextValue()
    }
}

/// A view modifier that monitors changes to player events and triggers a closure.
internal struct OnPlayerEventChangeModifier: ViewModifier {
    /// The closure to execute when player events change.
    var onPlayerEventChange: ([PlayerEvent]) -> Void

    /// Attaches a preference change listener to the content and executes a closure when player events change.
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(PlayerEventPreferenceKey.self, perform: onPlayerEventChange)
    }
}

/// Extends `View` to include a custom modifier for handling player event changes.
public extension View {
    /// Applies the `OnPlayerEventChangeModifier` to the view to handle player event changes.
    func onPlayerEventChange(perform action: @escaping ([PlayerEvent]) -> Void) -> some View {
        self.modifier(OnPlayerEventChangeModifier(onPlayerEventChange: action))
    }
}
