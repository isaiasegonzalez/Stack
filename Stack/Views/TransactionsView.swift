//
//  TransactionsView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI

struct TransactionsView: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @EnvironmentObject var creditCardViewModel: CreditCardViewModel

    @State private var selectedCardID: Int? = nil
    @State private var selectedRange: String = "Last 30 days"
    @State private var selectedCategory: String = "All"
    @State private var expandedTransactionID: Int? = nil

    // MARK: - Filters
    var filteredTransactions: [Transaction] {
        var result = transactionViewModel.transactions
        
        if let selectedCardID = selectedCardID {
            result = result.filter { $0.creditCardID == selectedCardID }
        }
        
        if selectedCategory != "All" {
            result = result.filter { $0.category == selectedCategory }
        }
        
        return result.sorted(by: { $0.date > $1.date })
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {

                    // MARK: - Select a Card
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            Button {
                                selectedCardID = nil
                            } label: {
                                Text("All Cards")
                                    .font(.subheadline)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .background(selectedCardID == nil ? Color.blue.opacity(0.2) : Color(.systemGray6))
                                    .cornerRadius(10)
                            }

                            ForEach(creditCardViewModel.creditCards) { card in
                                Button {
                                    selectedCardID = card.id
                                } label: {
                                    CardView(
                                        name: card.name,
                                        lightLogoImage: card.lightLogoImage,
                                        topGradientColor: card.topGradientColor,
                                        bottomGradientColor: card.bottomGradientColor,
                                        lastFourDigits: card.lastFourDigits
                                    )
                                    .frame(width: 180)
                                    .shadow(color: selectedCardID == card.id ? Color.black.opacity(0.25) : Color.clear,
                                            radius: 5, x: 0, y: 4)
                                    .scaleEffect(selectedCardID == card.id ? 1.05 : 1.0)
                                    .animation(.easeInOut(duration: 0.15), value: selectedCardID)
                                }
                            }
                        }
                        .padding()
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
                                .background(Color(.systemGray6))
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
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    // MARK: - Transactions List
                    VStack(alignment: .leading, spacing: 0) {
                        Text("All Transactions")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.bottom, 6)
                        Divider()
                            .padding(.horizontal)
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
                                        Text("+$\(txn.cashback, specifier: "%.2f")")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }

                                // Better card badge
                                if txn.bestCardID != nil {
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
                                if expandedTransactionID == txn.id,
                                   let usedCard = creditCardViewModel.creditCards.first(where: { $0.id == txn.creditCardID }),
                                   let bestCardID = txn.bestCardID,
                                   let bestCard = creditCardViewModel.creditCards.first(where: { $0.id == bestCardID }) {

                                    VStack(alignment: .leading, spacing: 10) {
                                        Divider()

                                        // Card used
                                        HStack {
                                            Image(usedCard.darkLogoImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40)
                                                .cornerRadius(6)

                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Card used")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Text(usedCard.name)
                                            }

                                            Spacer()
                                            Text("+$\(txn.cashback, specifier: "%.2f")")
                                                .bold()
                                        }

                                        // Better card
                                        HStack {
                                            Image(bestCard.darkLogoImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 24)
                                                .cornerRadius(6)

                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Better card")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Text(bestCard.name)
                                            }

                                            Spacer()
                                            Text("+$\(txn.potentialCashback ?? 0, specifier: "%.2f")")
                                                .bold()
                                                .foregroundColor(.orange)
                                        }
                                    }
                                    .padding(.vertical, 6)
                                }
                                Divider()
                                    .padding(.top, 6)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGray6))
        }
    }
}

#Preview {
    TransactionsView()
        .environmentObject(CreditCardViewModel())
        .environmentObject(TransactionViewModel())
}
