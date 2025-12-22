//
//  HomeView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \CreditCard.name) var cards: [CreditCard]
    @Query(sort: \Transaction.date, order: .reverse) var transactions: [Transaction]
    
    @Environment(\.modelContext) private var context
    @EnvironmentObject var creditCardViewModel: CreditCardViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    
    // Compute total balance dynamically
    var recentTransactions: [Transaction] {
        Array(transactions.prefix(5))
    }
    
    var totalBalance: Double {
        cards.reduce(0) { $0 + $1.balance }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 24) {
                    RewardsPerformanceView()
                        .padding(.top, 8)
                    
                    // Active Cards Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Active Cards")
                                    .font(.headline)
                                Text("Total Balance: $\(totalBalance, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            NavigationLink(destination: CardsView()) {
                                HStack(spacing: 2) {
                                    Text("View All")
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        Divider()
                            .padding(.horizontal)
                        if cards.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "creditcard")
                                    .font(.system(size: 32))
                                    .foregroundColor(.gray.opacity(0.6))
                                Text("No cards added yet")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Tap 'View All' to get started.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .padding(.vertical, 8)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(cards) { card in
                                        VStack(alignment: .leading, spacing: 10) {
                                            CardView(
                                                name: card.name,
                                                lightLogoImage: card.lightLogoImage,
                                                topGradientColor: card.topGradientColor,
                                                bottomGradientColor: card.bottomGradientColor,
                                                lastFourDigits: card.lastFourDigits
                                            )
                                            .frame(width: 180)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("$\(card.balance, specifier: "%.2f")")
                                                    .font(.subheadline)
                                                    .bold()
                                                Text("Due \(card.dueDate.formatted(.dateTime.month(.abbreviated).day()))")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    // Recent Transactions Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Recent Transactions")
                                .font(.headline)
                            Spacer()
                            NavigationLink(destination: TransactionsView()) {
                                HStack(spacing: 2) {
                                    Text("View All")
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        if recentTransactions.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "tray")
                                    .font(.system(size: 32))
                                    .foregroundColor(.gray.opacity(0.6))
                                Text("No recent transactions")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Your latest activity will appear here.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .padding(.vertical, 8)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(recentTransactions) { txn in
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(txn.name)
                                                Text("\(txn.date.formatted(.dateTime.month(.abbreviated).day().year())) | \(txn.category)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                Text("$\(txn.amount, specifier: "%.2f")")
                                                Text("\(txn.cashback >= 0 ? "+" : "-")$\(abs(txn.cashback).formatted(.number.precision(.fractionLength(2))))")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        
                                        if let best = txn.bestCard {
                                            HStack(spacing: 4) {
                                                Image(systemName: "info.circle.fill")
                                                    .font(.caption)
                                                Text("Better card: \(best.name)")
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                            }
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(Color.orange.opacity(0.15))
                                            .cornerRadius(8)
                                            .foregroundColor(.orange)
                                        }
                                        Divider()
                                            .padding(.top, 6)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGray6))
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [CreditCard.self, Transaction.self], inMemory: true)
        .environmentObject(CreditCardViewModel())
        .environmentObject(TransactionViewModel())
}
