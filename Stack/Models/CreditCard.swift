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
    
    // Relationship to transactions
    @Relationship(deleteRule: .cascade) var transactions: [Transaction]
    
    init(
        name: String,
        balance: Double,
        dueDate: Date,
        benefits: String,
        lightLogoImage: String,
        darkLogoImage: String,
        topGradientColor: String,
        bottomGradientColor: String,
        lastFourDigits: String
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
        self.transactions = []
    }
}
