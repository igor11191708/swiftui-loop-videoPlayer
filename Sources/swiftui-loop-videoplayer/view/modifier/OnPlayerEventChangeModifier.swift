//
//  OnPlayerEventChangeModifier.swift
//
//
//  Created by Igor Shelopaev on 15.08.24.
//

import SwiftUI

internal struct PlayerEventPreferenceKey: PreferenceKey {
    public static var defaultValue: PlayerEvent = .idle
    public static func reduce(value: inout PlayerEvent, nextValue: () -> PlayerEvent) {
        value = nextValue()
    }
}

internal struct OnPlayerEventChangeModifier: ViewModifier {
    var onPlayerEventChange: (PlayerEvent) -> Void

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(PlayerEventPreferenceKey.self) { event in
                onPlayerEventChange(event)
            }
    }
}

public extension View {
    func onPlayerEventChange(perform action: @escaping (PlayerEvent) -> Void) -> some View {
        self.modifier(OnPlayerEventChangeModifier(onPlayerEventChange: action))
    }
}
