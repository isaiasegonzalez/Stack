//
//  Transaction.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import Foundation

// Identifiable: Uniquely identifies instances of a type (in this case, instances of City or identifiable).
// Codable: Allows you to easily convert data between a Swift type and an external format like JSON (needed for JSONEncoder/Decoder).
// Equatable: Capable of being compared for equality or equated (needed for toggleFavorite: sees if city is already in favoriteCities array).
struct Transaction: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let date: Date
    let amount: Double
    let category: String
    let cashback: Double
    let creditCardID: Int
    var bestCardID: Int? = nil
    var potentialCashback: Double? = nil
}
