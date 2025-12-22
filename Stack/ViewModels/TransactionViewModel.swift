//
//  TransactionViewModel.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/28/25.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class TransactionViewModel: ObservableObject {
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
