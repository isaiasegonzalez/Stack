//
//  AppFlowView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI

struct AppFlowView: View {
    @EnvironmentObject var creditCardViewModel: CreditCardViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    
    @State private var showMainApp = false
    @State private var showEmailEntry = false
    @State private var showSignUp = false
    
    var body: some View {
        ZStack {
            if showMainApp {
                ContentView()
                    .environmentObject(creditCardViewModel)
                    .environmentObject(transactionViewModel)
                    .transition(.opacity)
                
            } else if showSignUp {
                SignUpView(showMainApp: $showMainApp)
                    .transition(.opacity)
                
            } else if showEmailEntry {
                EmailEntryView(showMainApp: $showMainApp)
                    .transition(.opacity)
                
            } else {
                SplashScreenView()
                    .onAppear {
                        // after 2 seconds, move to email entry
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showEmailEntry = true
                            }
                        }
                    }
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    AppFlowView()
        .environmentObject(CreditCardViewModel())
        .environmentObject(TransactionViewModel())
}
