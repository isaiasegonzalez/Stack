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
    @State private var isUnlocked = false
    @State private var readyForAuth = false
    var body: some View {
        ZStack {
            if !readyForAuth {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            readyForAuth = true
                            authenticate()
                        }
                    }
            }
            else if isUnlocked {
                ContentView()
                    .environmentObject(creditCardViewModel)
                    .environmentObject(transactionViewModel)
                    .transition(.opacity)
            } else {
                lockedScreen
            }
        }
    }
    private var lockedScreen: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.fill")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("Unlock Stack")
                .font(.title2)
                .fontWeight(.semibold)
            Button(action: authenticate) {
                Label("Use Face ID", systemImage: "faceid")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 32)
        .transition(.opacity)
    }
    private func authenticate() {
        FaceIDManager.authenticate { success in
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isUnlocked = success
            }
        }
    }
}

#Preview {
    AppFlowView()
        .environmentObject(CreditCardViewModel())
        .environmentObject(TransactionViewModel())
}
