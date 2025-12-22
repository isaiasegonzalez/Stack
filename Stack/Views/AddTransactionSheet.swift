//
//  AddTransactionSheet.swift
//  Stack
//
//  Created by Isaias Gonzalez on 12/2/25.
//

import SwiftUI
import SwiftData

struct AddTransactionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    
    @Query(sort: \CreditCard.name) private var cards: [CreditCard]
    
    // Transaction fields
    @State private var name = ""
    @State private var date = Date()
    @State private var amount = ""
    @State private var category = "Dining"
    @State private var selectedCard: CreditCard? = nil

    private let categories = [
        "Dining", "Groceries", "Travel", "Shopping",
        "Transportation", "Streaming", "Other"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                // Basic transaction info
                Section(header: Text("Transaction Details")) {
                    TextField("Merchant Name", text: $name)
                        .onChange(of: name) {
                            name = String(name.prefix(30))
                        }
                    DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                        // Prevent selecting future dates
                        .onChange(of: date) {
                            if date > Date() { date = Date() }
                        }
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                }
                // Card Picker
                Section(header: Text("Card Used")) {
                    if cards.isEmpty {
                            Text("Add a card to begin adding transactions.")
                    } else {
                        Picker("Select Card", selection: $selectedCard) {
                            ForEach(cards) { card in
                                Text(card.name).tag(Optional(card))
                            }
                        }
                    }
                }
                // Save Button
                Button("Add Transaction") {
                    transactionViewModel.addTransaction(
                        name: name,
                        date: date,
                        rawAmount: amount,
                        category: category,
                        card: selectedCard,
                        cards: cards,
                        context: context
                    )
                    dismiss()
                }
                .disabled(formInvalid)
            }
            .navigationTitle("New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    // Validation
    var formInvalid: Bool {
        name.isEmpty ||
        Double(amount) == nil ||
        selectedCard == nil ||
        date > Date()
    }
}

#Preview {
    AddTransactionSheet()
        .modelContainer(for: [CreditCard.self, Transaction.self], inMemory: true)
}
