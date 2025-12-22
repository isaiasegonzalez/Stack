//
//  CreditCardViewModel.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/28/25.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class CreditCardViewModel: ObservableObject {
    // Creates a CreditCard from a template, assigns reward rules, and inserts into SwiftData.
    func addCard(
        from template: CreditCardTemplate,
        dueDate: Date,
        lastFourDigits: String,
        context: ModelContext
    ) {
        
        let card = CreditCard(
            name: template.name,
            balance: 0,
            dueDate: dueDate,
            benefits: template.benefits,
            lightLogoImage: template.lightLogoImage,
            darkLogoImage: template.darkLogoImage,
            topGradientColor: template.topGradientColor,
            bottomGradientColor: template.bottomGradientColor,
            lastFourDigits: lastFourDigits,
            usesPoints: template.usesPoints,
            pointToCashRate: template.pointToCashRate
        )
        
        // Assign reward rules
        let rules = rewardRules(for: template.name)
        
        for (category, multiplier) in rules {
            let rule = RewardRule(category: category, multiplier: multiplier, card: card)
            card.rewards.append(rule)
            }
            context.insert(card)
        }
     
     // Returns correct reward rule set for each card
    private func rewardRules(for cardName: String) -> [String: Double] {
        switch cardName {
         case "Sapphire Reserve":
             return RewardDefinitions.sapphireReserve
         case "Gold Card":
             return RewardDefinitions.goldCard
         case "Venture X":
             return RewardDefinitions.ventureX
         default:
             return ["Other": 0]
         }
     }
     
    func fetchAllCards(context: ModelContext) -> [CreditCard] {
        let descriptor = FetchDescriptor<CreditCard>(sortBy: [SortDescriptor(\.name)])
        return (try? context.fetch(descriptor)) ?? []
    }
}
