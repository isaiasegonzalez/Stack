//
//  SignUpView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI

struct SignUpView: View {
    @Binding var showMainApp: Bool
    
    @State private var firstName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    private var isFormValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty &&
        password == confirmPassword
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer().frame(height: 60)
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Please fill out required fields")
                .font(.body)
                .foregroundColor(.secondary)
            TextField("First Name", text: $firstName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            // Continue Button
            Button(action: {
                if isFormValid {
                    withAnimation(.easeInOut) {
                        showMainApp = true
                    }
                }
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!isFormValid)
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignUpView(showMainApp: .constant(false))
}
