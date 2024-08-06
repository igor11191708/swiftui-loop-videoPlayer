//
//  PlayerErrorCoordinator.swift
//
//
//  Created by Igor  on 06.08.24.
//

import SwiftUI

@MainActor
internal class PlayerErrorCoordinator: NSObject, PlayerErrorDelegate {
    
    @Binding private var error: VPErrors?
   
    init(_ error: Binding<VPErrors?>) {
        self._error = error
    }
    
    deinit {
        #if DEBUG
        print("deinit Coordinator")
        #endif
    }
    
    /// Handles receiving an error and updates the error state in the parent view
    /// - Parameter error: The error received
    func didReceiveError(_ error: VPErrors) {
            self.error = error
    }
}
