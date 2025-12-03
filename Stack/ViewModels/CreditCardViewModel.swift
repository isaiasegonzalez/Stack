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
    // Create a new card and insert into SwiftData
    func addCreditCard(
        name: String,
        balance: Double,
        dueDate: Date,
        benefits: String,
        lightLogoImage: String,
        darkLogoImage: String,
        topGradientColor: String,
        bottomGradientColor: String,
        lastFourDigits: String,
        context: ModelContext
    ) {
        let card = CreditCard(
            name: name,
            balance: balance,
            dueDate: dueDate,
            benefits: benefits,
            lightLogoImage: lightLogoImage,
            darkLogoImage: darkLogoImage,
            topGradientColor: topGradientColor,
            bottomGradientColor: bottomGradientColor,
            lastFourDigits: lastFourDigits
        )
        
        context.insert(card)
    }
    
    func fetchAllCards(context: ModelContext) -> [CreditCard] {
        let descriptor = FetchDescriptor<CreditCard>(sortBy: [SortDescriptor(\.name)])
        return (try? context.fetch(descriptor)) ?? []
    }
}
