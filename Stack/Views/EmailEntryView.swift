//
//  EmailEntryView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI

struct EmailEntryView: View {
    @Binding var showMainApp: Bool
    
    @State private var email = ""
    @State private var navigateToSignUp = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Spacer().frame(height: 60)
                
                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Please enter your email.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                TextField("example@email.com", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                // Continue Button
                Button(action: {
                    if !email.trimmingCharacters(in: .whitespaces).isEmpty {
                        navigateToSignUp = true
                    }
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(email.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray.opacity(0.4) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(email.trimmingCharacters(in: .whitespaces).isEmpty)
                Text("""
                By proceeding, you agree to our \
                Terms & Conditions and Privacy Policy
                """)
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .padding(.top, 8)
                
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToSignUp) {
                SignUpView(showMainApp: $showMainApp)
            }
        }
    }
}

#Preview {
    EmailEntryView(showMainApp: .constant(false))
}
