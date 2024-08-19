//
//  OnTimeChangeModifier.swift
//
//
//  Created by Igor Shelopaev on 15.08.24.
//

import SwiftUI

/// Defines a custom `PreferenceKey` for storing and updating the current playback time.
internal struct CurrentTimePreferenceKey: PreferenceKey {
    /// Sets the default playback time to 0.0 seconds.
    public static var defaultValue: Double = 0.0
    
    /// Aggregates the most recent playback time from child views.
    public static func reduce(value: inout Double, nextValue: () -> Double) {
        value = nextValue()
    }
}

/// A view modifier that listens for changes in playback time and triggers a response.
internal struct OnTimeChangeModifier: ViewModifier {
    /// The closure to execute when there is a change in playback time.
    var onTimeChange: (Double) -> Void

    /// Attaches a preference change listener to the content that triggers `onTimeChange` when the playback time updates.
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(CurrentTimePreferenceKey.self, perform: onTimeChange)
    }
}

/// Extends `View` to include functionality for responding to changes in playback time.
public extension View {
    /// Applies the `OnTimeChangeModifier` to the view to manage updates in playback time.
    func onPlayerTimeChange(perform action: @escaping (Double) -> Void) -> some View {
        self.modifier(OnTimeChangeModifier(onTimeChange: action))
    }
}
