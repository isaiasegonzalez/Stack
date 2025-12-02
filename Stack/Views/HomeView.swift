//
//  HomeView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    @EnvironmentObject var creditCardViewModel: CreditCardViewModel

    // Compute total balance dynamically
    var totalBalance: Double {
        creditCardViewModel.creditCards.reduce(0) { $0 + $1.balance }
    }
    
    var recentTransactions: [Transaction] {
        let sorted = transactionViewModel.transactions.sorted(by: { $0.date > $1.date })
        return Array(sorted.prefix(5))
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 24) {
                    RewardsPerformanceView()
                        .padding(.top, 8)
                    
                    // Active Cards Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Active Cards")
                                    .font(.headline)
                                Text("Total Balance: $\(String(format: "%.2f", totalBalance))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            NavigationLink(destination: CardsView()
                                .environmentObject(creditCardViewModel)
                                .environmentObject(transactionViewModel)
                            ) {
                                HStack(spacing: 2) {
                                    Text("View All")
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(creditCardViewModel.creditCards) { card in
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
                                            Text("$\(String(format: "%.2f", card.balance))")
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

                    // Recent Transactions Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Recent Transactions")
                                .font(.headline)
                            Spacer()
                            NavigationLink(destination: TransactionsView()
                                .environmentObject(transactionViewModel)
                                .environmentObject(creditCardViewModel)
                            ) {
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
                                            Text("+$\(txn.cashback, specifier: "%.2f")")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    
                                    if txn.bestCardID != nil {
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
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGray6))
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(CreditCardViewModel())
        .environmentObject(TransactionViewModel())
}
