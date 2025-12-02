//
//  TransactionViewModel.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/28/25.
//

import Foundation
import Combine

@MainActor
class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = [] {
        didSet { saveTransactions() }
    }
    
    private let storageKey = "SavedTransactions"
    
    init() {
        loadTransactions()
    }
    
    // MARK: - Load Transactions
    func loadTransactions() {
        self.transactions = [
            // Transactions for Chase Sapphire Reserve (id: 1)
            Transaction(
                id: 1,
                name: "Starbucks",
                date: ISO8601DateFormatter().date(from: "2025-10-22T09:30:00Z")!,
                amount: 8.75,
                category: "Dining",
                cashback: 0.26,
                creditCardID: 1,
                bestCardID: 2,
                potentialCashback: 0.44
            ),
            Transaction(
                id: 2,
                name: "Uber",
                date: ISO8601DateFormatter().date(from: "2025-09-18T21:15:00Z")!,
                amount: 22.40,
                category: "Travel",
                cashback: 0.67,
                creditCardID: 1,
                bestCardID: 3,
                potentialCashback: 1.55
            ),
            Transaction(
                id: 3,
                name: "Amazon",
                date: ISO8601DateFormatter().date(from: "2025-07-05T13:00:00Z")!,
                amount: 54.99,
                category: "Shopping",
                cashback: 0.55,
                creditCardID: 1
            ),
            
            // Transactions for Amex Gold (id: 2)
            Transaction(
                id: 4,
                name: "Whole Foods",
                date: ISO8601DateFormatter().date(from: "2025-03-26T16:45:00Z")!,
                amount: 64.20,
                category: "Groceries",
                cashback: 1.92,
                creditCardID: 2
            ),
            Transaction(
                id: 5,
                name: "Chipotle",
                date: ISO8601DateFormatter().date(from: "2025-02-14T12:10:00Z")!,
                amount: 14.50,
                category: "Dining",
                cashback: 0.58,
                creditCardID: 2
            ),
            Transaction(
                id: 6,
                name: "Delta Airlines",
                date: ISO8601DateFormatter().date(from: "2024-12-28T08:00:00Z")!,
                amount: 320.00,
                category: "Travel",
                cashback: 9.60,
                creditCardID: 2,
                bestCardID: 3,
                potentialCashback: 12.80
            ),
            
            // Transactions for Capital One Venture X (id: 3)
            Transaction(
                id: 7,
                name: "Spotify",
                date: ISO8601DateFormatter().date(from: "2024-11-10T07:20:00Z")!,
                amount: 9.99,
                category: "Entertainment",
                cashback: 0.20,
                creditCardID: 3
            ),
            Transaction(
                id: 8,
                name: "Target",
                date: ISO8601DateFormatter().date(from: "2025-04-12T18:05:00Z")!,
                amount: 43.80,
                category: "Shopping",
                cashback: 0.87,
                creditCardID: 3
            ),
            Transaction(
                id: 9,
                name: "United Airlines",
                date: ISO8601DateFormatter().date(from: "2024-10-30T10:30:00Z")!,
                amount: 241.50,
                category: "Travel",
                cashback: 7.25,
                creditCardID: 3
            )
        ]
    }
    
    // Save Transactions
    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    // Filter by Card
    func transactions(for cardID: Int) -> [Transaction] {
        transactions.filter { $0.creditCardID == cardID }
    }
}
