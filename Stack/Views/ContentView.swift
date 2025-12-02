//
//  ContentView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/28/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var creditCardViewModel: CreditCardViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            TransactionsView()
                .tabItem {
                    Label("Transactions", systemImage: "dollarsign.arrow.circlepath")
                }
            CardsView()
                .tabItem {
                    Label("Cards", systemImage: "creditcard.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CreditCardViewModel())
        .environmentObject(TransactionViewModel())
}
