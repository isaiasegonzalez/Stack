//
//  AddCardSheet.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI
import SwiftData

struct AddCardSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \CreditCard.name) private var userCards: [CreditCard]
    
    // Predefined templates (static list)
    private let templates = cardTemplates
    
    var filteredTemplates: [CreditCardTemplate] {
        templates.filter { template in
            userCards.contains(where: { $0.name == template.name }) == false
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Popular Cards")) {
                    ForEach(filteredTemplates) { template in
                        NavigationLink {
                            CardSetupView(template: template)
                        } label: {
                            HStack(spacing: 12) {
                                Image(template.darkLogoImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 30)
                                Text(template.name)
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("Add a Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

struct CardSetupView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cardViewModel: CreditCardViewModel
    
    let template: CreditCardTemplate
    
    @State private var dueDate = Date()
    @State private var lastFourDigits = ""
    
    var body: some View {
        Form {
            Section(header: Text("Card Details")) {
                Text(template.name)
                    .font(.headline)
                
                DatePicker(
                    "Due Date",
                    selection: $dueDate,
                    in: Date()...,   // prevents past dates
                    displayedComponents: .date
                )
                .onChange(of: dueDate) {
                    if dueDate < Date() {
                        dueDate = Date()
                    }
                }
                
                // last 4 digits: numeric only and max 4 characters
                TextField("Last 4 Digits", text: $lastFourDigits)
                    .keyboardType(.numberPad)
                    .onChange(of: lastFourDigits) {
                        // keep only digits
                        let numeric = lastFourDigits.filter { $0.isNumber }
                        // allow max 4 characters
                        lastFourDigits = String(numeric.prefix(4))
                    }
            }
            
            Button("Add Card") {
                cardViewModel.addCard(from: template,
                                      dueDate: dueDate,
                                      lastFourDigits: lastFourDigits,
                                      context: context)
                dismiss()
            }
            .disabled(!formValid)
        }
        .navigationTitle("Set Up Card")
    }
    
    var formValid: Bool {
        lastFourDigits.count == 4 &&
        dueDate >= Calendar.current.startOfDay(for: Date())
    }
}

#Preview {
    AddCardSheet()
        .modelContainer(
            for: [CreditCard.self, Transaction.self],
            inMemory: true
        )
}
