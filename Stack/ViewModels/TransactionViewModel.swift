//
//  TransactionViewModel.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/28/25.
//  Edited by Jessica Lin on 1/3/2026.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class TransactionViewModel: ObservableObject {

    // UI state (for screens that want an in-memory list, not @Query)
    @Published var transactions: [Transaction] = []

    // Repo is optional so you can still do TransactionViewModel()
    // from StackApp.swift without needing to pass anything in yet.
    private var repository: TransactionRepository?

    init(repository: TransactionRepository? = nil) {
        self.repository = repository
    }

    /// Call this later (e.g. in AppFlowView) once you have a ModelContext
    /// and can build LocalTransactionRepository(context: ...)
    func configure(repository: TransactionRepository) {
        self.repository = repository
    }

    /// Loads transactions via the repository (local SwiftData today, remote API later).
    func loadTransactions() async {
        guard let repository else { return }
        do {
            transactions = try await repository.fetchTransactions()
        } catch {
            print("Failed to load transactions:", error)
        }
    }

    /// Loads transactions from local SwiftData using ModelContext.
    /// (Later you will swap this to remote API / Plaid by changing the repository.)
    func loadTransactionsFromLocal(context: ModelContext) async {
        let repo = LocalTransactionRepository(context: context)
        configure(repository: repo)
        await loadTransactions()
    }

    // Add Transaction (main logic)
    func addTransaction(
        name: String,
        date: Date,
        rawAmount: String,
        category: String,
        card: CreditCard?,
        cards: [CreditCard],
        context: ModelContext
    ) {
        guard let card = card,
              let amountDouble = Double(rawAmount) else { return }
        
        // Round input
        let amount = amountDouble.rounded(toPlaces: 2)
        
        // Cashback for used card
        let cashback = card.cashback(for: category, amount: amount)
        
        // Best card calculation (only among user's added cards)
        let best = bestCardFor(category: category, amount: amount, cards: cards, usedCard: card)
        
        // Create transaction
        let txn = Transaction(
            name: name,
            date: date,
            amount: amount,
            category: category,
            cashback: cashback,
            potentialCashback: best.potential,
            creditCard: card,
            bestCard: best.best
        )
        
        // Update balance (refunds work bc amount may be negative)
        card.balance += amount
        
        // Save to SwiftData
        context.insert(txn)
    }
    
    func deleteTransaction(_ txn: Transaction, context: ModelContext) {
        // Reverse card balance
        if let card = txn.creditCard {
            card.balance -= txn.amount
        }
        // Delete from SwiftData
        context.delete(txn)
    }
    
    // Best Card Evaluation Helper ~ where the magic happens!
    private func bestCardFor(
        category: String,
        amount: Double,
        cards: [CreditCard],
        usedCard: CreditCard
    ) -> (best: CreditCard?, potential: Double?) {
        
        var bestCard: CreditCard? = nil
        var bestValue: Double = 0
        
        for card in cards {
            let value = card.cashback(for: category, amount: amount)
            if value > bestValue {
                bestValue = value
                bestCard = card
            }
        }
        
        // If the used card is already the best → no suggestion
        if bestCard?.id == usedCard.id {
            return (nil, nil)
        }
        
        return (bestCard, bestValue)
    }
}
