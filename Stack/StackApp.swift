//
//  StackApp.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/28/25.
//

import SwiftUI
import SwiftData

@main
struct StackApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CreditCardViewModel())
                .environmentObject(TransactionViewModel())
        }
        .modelContainer(for: [CreditCard.self, Transaction.self])
    }
}
