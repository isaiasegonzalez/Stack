//
//  CreditCard.swift
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
class CreditCard {
    @Attribute(.unique) var id: UUID
    var name: String
    var balance: Double
    var dueDate: Date
    var benefits: String
    var lightLogoImage: String
    var darkLogoImage: String
    var topGradientColor: String
    var bottomGradientColor: String
    var lastFourDigits: String
    var usesPoints: Bool
    var pointToCashRate: Double?
    
    // Relationship to transactions
    @Relationship(deleteRule: .cascade) var transactions: [Transaction]
    // Relationship to credit card rewards
    @Relationship(deleteRule: .cascade) var rewards: [RewardRule]
    
    init(
        name: String,
        balance: Double,
        dueDate: Date,
        benefits: String,
        lightLogoImage: String,
        darkLogoImage: String,
        topGradientColor: String,
        bottomGradientColor: String,
        lastFourDigits: String,
        usesPoints: Bool,
        pointToCashRate: Double?
    ) {
        self.id = UUID()
        self.name = name
        self.balance = balance
        self.dueDate = dueDate
        self.benefits = benefits
        self.lightLogoImage = lightLogoImage
        self.darkLogoImage = darkLogoImage
        self.topGradientColor = topGradientColor
        self.bottomGradientColor = bottomGradientColor
        self.lastFourDigits = lastFourDigits
        self.usesPoints = usesPoints
        self.pointToCashRate = pointToCashRate
        self.transactions = []
        self.rewards = []
    }
}

extension CreditCard {
    func cashback(for category: String, amount: Double) -> Double {
        // find direct category match
        if let rule = rewards.first(where: { $0.category == category }) {
            return amount * rule.multiplier
        }
        // fallback to "Other"
        if let fallback = rewards.first(where: { $0.category == "Other" }) {
            return amount * fallback.multiplier
        }
        // else return 0
        return 0
    }
}

extension Array where Element == CreditCard {
    func bestCard(for category: String, amount: Double) -> (card: CreditCard?, cashback: Double) {
        var best: CreditCard? = nil
        var bestCashback: Double = 0
        
        for card in self {
            let earned = card.cashback(for: category, amount: amount)
            if earned > bestCashback {
                bestCashback = earned
                best = card
            }
        }
        
        return (best, bestCashback)
    }
}
