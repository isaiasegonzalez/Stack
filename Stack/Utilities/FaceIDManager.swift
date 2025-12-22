//
//  FaceIDManager.swift
//  Stack
//
//  Created by Isaias Gonzalez on 12/2/25.
//

import LocalAuthentication

class FaceIDManager {
    static func authenticate(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        // Check if biometrics are available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock Stack"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            // No FaceID/TouchID available (simulator) → allow access
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
}
