//
//  OnTimeChangeModifier.swift
//
//
//  Created by Igor  on 15.08.24.
//

import SwiftUI

internal struct CurrentTimePreferenceKey: PreferenceKey {
    public static var defaultValue: Double = 0.0
    public static func reduce(value: inout Double, nextValue: () -> Double) {
        value = nextValue()
    }
}

internal struct OnTimeChangeModifier: ViewModifier {
    var onTimeChange: (Double) -> Void

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(CurrentTimePreferenceKey.self) { time in
                onTimeChange(time)
            }
    }
}

public extension LoopPlayerView {
    func onTimeChange(perform action: @escaping (Double) -> Void) -> some View {
        self.modifier(OnTimeChangeModifier(onTimeChange: action))
    }
}
