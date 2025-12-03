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
    // Create and insert a Transaction into SwiftData
    func addTransaction(
        name: String,
        date: Date,
        amount: Double,
        category: String,
        cashback: Double,
        card: CreditCard,
        context: ModelContext
    ) {
        let transaction = Transaction(
            name: name,
            date: date,
            amount: amount,
            category: category,
            cashback: cashback,
            creditCard: card
        )
        context.insert(transaction)
    }
    
    // Example data, deleting later
    func loadDemoTransactions(context: ModelContext, cards: [CreditCard]) {
        let existing = try? context.fetch(FetchDescriptor<Transaction>())
        guard let transactions = existing, transactions.isEmpty else { return }
        guard cards.count >= 3 else { return }
        let sapphire = cards[0]
        let gold = cards[1]
        let venture = cards[2]
        let demo = [
            // MARK: - Sapphire Reserve
            Transaction(
                name: "Starbucks",
                date: ISO8601DateFormatter().date(from: "2025-10-22T09:30:00Z")!,
                amount: 8.75,
                category: "Dining",
                cashback: 0.26,
                potentialCashback: 0.44,
                creditCard: sapphire,
                bestCard: gold
            ),
            Transaction(
                name: "Uber",
                date: ISO8601DateFormatter().date(from: "2025-09-18T21:15:00Z")!,
                amount: 22.40,
                category: "Travel",
                cashback: 0.67,
                potentialCashback: 1.55,
                creditCard: sapphire,
                bestCard: venture
            ),
            Transaction(
                name: "Amazon",
                date: ISO8601DateFormatter().date(from: "2025-07-05T13:00:00Z")!,
                amount: 54.99,
                category: "Shopping",
                cashback: 0.55,
                potentialCashback: nil,
                creditCard: sapphire,
                bestCard: nil
            ),
            // MARK: - Gold Card
            Transaction(
                name: "Whole Foods",
                date: ISO8601DateFormatter().date(from: "2025-03-26T16:45:00Z")!,
                amount: 64.20,
                category: "Groceries",
                cashback: 1.92,
                potentialCashback: nil,
                creditCard: gold,
                bestCard: nil
            ),
            Transaction(
                name: "Chipotle",
                date: ISO8601DateFormatter().date(from: "2025-02-14T12:10:00Z")!,
                amount: 14.50,
                category: "Dining",
                cashback: 0.58,
                potentialCashback: nil,
                creditCard: gold,
                bestCard: nil
            ),
            Transaction(
                name: "Delta Airlines",
                date: ISO8601DateFormatter().date(from: "2024-12-28T08:00:00Z")!,
                amount: 320.00,
                category: "Travel",
                cashback: 9.60,
                potentialCashback: 12.80,
                creditCard: gold,
                bestCard: venture
            ),
            // MARK: - Venture X
            Transaction(
                name: "Spotify",
                date: ISO8601DateFormatter().date(from: "2024-11-10T07:20:00Z")!,
                amount: 9.99,
                category: "Entertainment",
                cashback: 0.20,
                potentialCashback: nil,
                creditCard: venture,
                bestCard: nil
            ),
            Transaction(
                name: "Target",
                date: ISO8601DateFormatter().date(from: "2025-04-12T18:05:00Z")!,
                amount: 43.80,
                category: "Shopping",
                cashback: 0.87,
                potentialCashback: nil,
                creditCard: venture,
                bestCard: nil
            ),
            Transaction(
                name: "United Airlines",
                date: ISO8601DateFormatter().date(from: "2024-10-30T10:30:00Z")!,
                amount: 241.50,
                category: "Travel",
                cashback: 7.25,
                potentialCashback: nil,
                creditCard: venture,
                bestCard: nil
            )
        ]
        demo.forEach { context.insert($0) }
    }
}
