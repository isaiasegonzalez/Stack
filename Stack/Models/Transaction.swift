//
//  Transaction.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import Foundation
import SwiftData

// SwiftData Migration Notes:
// - Converted struct → class (SwiftData requires reference types)
// - Added @Model annotation for persistence
// - Changed id from Int → UUID for safer unique identifiers
// - Properties must be var for SwiftData tracking
// - Added relationships between cards and transactions
// - Removed Codable/Equatable (handled automatically)

@Model
class Transaction {
    @Attribute(.unique) var id: UUID
    var name: String
    var date: Date
    var amount: Double
    var category: String
    var cashback: Double
    var potentialCashback: Double?

    // Relationship to CreditCard
    @Relationship var creditCard: CreditCard?
    @Relationship var bestCard: CreditCard?

    init(
        name: String,
        date: Date,
        amount: Double,
        category: String,
        cashback: Double,
        potentialCashback: Double? = nil,
        creditCard: CreditCard? = nil,
        bestCard: CreditCard? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.amount = amount
        self.category = category
        self.cashback = cashback
        self.potentialCashback = potentialCashback
        self.creditCard = creditCard
        self.bestCard = bestCard
    }
}
