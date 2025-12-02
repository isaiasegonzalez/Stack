//
//  StackApp.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/28/25.
//

import SwiftUI

@main
struct StackApp: App {
    @EnvironmentObject var creditCardViewModel: CreditCardViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    var body: some Scene {
        WindowGroup {
            AppFlowView()
                .environmentObject(CreditCardViewModel())
                .environmentObject(TransactionViewModel())
        }
    }
}
