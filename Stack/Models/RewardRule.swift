//
//  RewardRule.swift
//  Stack
//
//  Created by Isaias Gonzalez on 12/2/25.
//

import Foundation
import SwiftData

@Model
class RewardRule {
    var category: String      // ex: "Dining", "Travel", "Other"
    var multiplier: Double    // ex: 0.03 for 3% cashback
    
    // Relationship back to the card
    @Relationship(inverse: \CreditCard.rewards)
    var card: CreditCard?

    init(category: String, multiplier: Double, card: CreditCard? = nil) {
        self.category = category
        self.multiplier = multiplier
        self.card = card
    }
}

struct RewardDefinitions {
    static let sapphireReserve: [String: Double] = [
        "Dining": 0.03,
        "Travel": 0.03,
        "Other": 0.01
    ]

    static let goldCard: [String: Double] = [
        "Dining": 0.04,
        "Groceries": 0.04,
        "Travel": 0.03,
        "Other": 0.01
    ]

    static let ventureX: [String: Double] = [
        "Travel": 0.05,
        "Hotels": 0.10,
        "Other": 0.02
    ]
}
