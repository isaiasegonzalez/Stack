//
//  TransactionsView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Query var cards: [CreditCard]
    
    @Environment(\.modelContext) private var context
    @EnvironmentObject var transactionVM: TransactionViewModel

    
    @State private var selectedCard: CreditCard? = nil
    @State private var selectedRange: String = "All time"
    @State private var selectedCategory: String = "All"
    @State private var expandedTransactionID: UUID? = nil
    @State private var showAddTransactionSheet = false
    
    // Filters
    var filteredTransactions: [Transaction] {
        var result = transactionVM.transactions
        if let selectedCard = selectedCard {
            result = result.filter { $0.creditCard?.id == selectedCard.id }
        }
        if selectedCategory != "All" {
            result = result.filter { $0.category == selectedCategory }
        }
        result = applyDateFilter(result)
        return result.sorted(by: { $0.date > $1.date })
    }
    
    private func applyDateFilter(_ txns: [Transaction]) -> [Transaction] {
        let now = Date()
        switch selectedRange {
        case "Last 7 days":
            return txns.filter { $0.date >= now.addingTimeInterval(-7 * 24 * 60 * 60) }
        case "Last 30 days":
            return txns.filter { $0.date >= now.addingTimeInterval(-30 * 24 * 60 * 60) }
        default:
            return txns
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // MARK: - Select a Card
                    if cards.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "creditcard")
                                .font(.system(size: 34))
                                .foregroundColor(.gray.opacity(0.6))
                            Text("No cards added yet")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Add a card to begin tracking transactions.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                Button {
                                    selectedCard = nil
                                } label: {
                                    Text("All Cards")
                                        .font(.subheadline)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .background(selectedCard == nil ? Color.blue.opacity(0.2) : Color(.systemGray6))
                                        .cornerRadius(10)
                                }
                                
                                ForEach(cards) { card in
                                    Button {
                                        selectedCard = card
                                    } label: {
                                        CardView(
                                            name: card.name,
                                            lightLogoImage: card.lightLogoImage,
                                            topGradientColor: card.topGradientColor,
                                            bottomGradientColor: card.bottomGradientColor,
                                            lastFourDigits: card.lastFourDigits
                                        )
                                        .frame(width: 180)
                                        .shadow(color: selectedCard?.id == card.id ? Color.black.opacity(0.25) : Color.clear,
                                                radius: 5, x: 0, y: 4)
                                        .scaleEffect(selectedCard?.id == card.id ? 1.05 : 1.0)
                                        .animation(.easeInOut(duration: 0.15), value: selectedCard)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    // MARK: - Filters
                    HStack(spacing: 12) {
                        Menu {
                            Button("Last 7 days") { selectedRange = "Last 7 days" }
                            Button("Last 30 days") { selectedRange = "Last 30 days" }
                            Button("All time") { selectedRange = "All time" }
                        } label: {
                            Label(selectedRange, systemImage: "calendar")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.white))
                                .cornerRadius(10)
                        }
                        Menu {
                            Button("All") { selectedCategory = "All" }
                            Button("Dining") { selectedCategory = "Dining" }
                            Button("Groceries") { selectedCategory = "Groceries" }
                            Button("Travel") { selectedCategory = "Travel" }
                            Button("Shopping") { selectedCategory = "Shopping" }
                            Button("Transportation") { selectedCategory = "Transportation" }
                            Button("Streaming") { selectedCategory = "Streaming" }
                        } label: {
                            Label(selectedCategory, systemImage: "line.3.horizontal.decrease.circle")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.white))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    // Jessica Added
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Repository loaded: \(transactionVM.transactions.count) txns")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    // Transactions List
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                            Text("All Transactions")
                                .font(.headline)
                            Spacer()
                            Button {
                                showAddTransactionSheet = true
                            } label: {
                                HStack(spacing: 4) {
                                    Text("Add")
                                    Image(systemName: "plus")
                                }
                                .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                        Divider()
                            .padding(.horizontal)
                        if filteredTransactions.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "tray")
                                    .font(.system(size: 34))
                                    .foregroundColor(.gray.opacity(0.6))
                                Text("No transactions found")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Your activity will appear here once added.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        } else {
                            ForEach(filteredTransactions) { txn in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(txn.name)
                                            Text("\(txn.date.formatted(.dateTime.month(.abbreviated).day().year())) | \(txn.category)")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text("$\(txn.amount, specifier: "%.2f")")
                                            Text("\(txn.cashback >= 0 ? "+" : "-")$\(abs(txn.cashback).formatted(.number.precision(.fractionLength(2))))")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    // Better card badge
                                    if txn.bestCard != nil {
                                        Button {
                                            withAnimation(.easeInOut) {
                                                expandedTransactionID = expandedTransactionID == txn.id ? nil : txn.id
                                            }
                                        } label: {
                                            HStack(spacing: 4) {
                                                Image(systemName: "info.circle.fill")
                                                    .font(.caption)
                                                Text("Better card available")
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                            }
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(Color.orange.opacity(0.15))
                                            .cornerRadius(8)
                                            .foregroundColor(Color.orange)
                                        }
                                    }
                                    // Expanded Row (Accordion)
                                    if expandedTransactionID == txn.id {
                                        TransactionDetailAccordion(txn: txn)
                                    }
                                    Divider()
                                        .padding(.top, 6)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            // Undo the effect of this transaction on the card balance
                                            if let card = txn.creditCard {
                                                card.balance -= txn.amount
                                            }
                                            context.delete(txn)
                                            Task { await transactionVM.loadTransactionsFromLocal(context: context) }
                                        }
                                    } label: {
                                        Label("Delete Transaction", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGray6))
            .sheet(isPresented: $showAddTransactionSheet, onDismiss: {
                Task { await transactionVM.loadTransactionsFromLocal(context: context) }
            }) {
                AddTransactionSheet()
            }
            .task {
                await transactionVM.loadTransactionsFromLocal(context: context)
            }
        }
    }
}

// Accordion Component
struct TransactionDetailAccordion: View {
    let txn: Transaction
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Divider()
            // Card used
            if let used = txn.creditCard {
                HStack {
                    Image(used.darkLogoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .cornerRadius(6)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Card used")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(used.name)
                    }
                    Spacer()
                    Text("+$\(txn.cashback, specifier: "%.2f")")
                        .bold()
                }
            }
            // Better card
            if let best = txn.bestCard {
                HStack {
                    Image(best.darkLogoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 24)
                        .cornerRadius(6)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Better card")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(best.name)
                    }
                    Spacer()
                    Text("+$\(txn.potentialCashback ?? 0, specifier: "%.2f")")
                        .bold()
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    TransactionsView()
        .modelContainer(for: [CreditCard.self, Transaction.self], inMemory: true)
        .environmentObject(CreditCardViewModel())
        .environmentObject(TransactionViewModel())
}
