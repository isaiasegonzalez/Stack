//
//  CreditCard.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import Foundation

// Identifiable: Uniquely identifies instances of a type (in this case, instances of City or identifiable).
// Codable: Allows you to easily convert data between a Swift type and an external format like JSON (needed for JSONEncoder/Decoder).
// Equatable: Capable of being compared for equality or equated (needed for toggleFavorite: sees if city is already in favoriteCities array).
struct CreditCard: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let balance: Double
    let dueDate: Date
    let benefits: String
    let lightLogoImage: String
    let darkLogoImage: String
    let topGradientColor: String
    let bottomGradientColor: String
    let lastFourDigits: String
}
