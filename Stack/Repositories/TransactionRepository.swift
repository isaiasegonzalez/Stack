//
//  TransactionRepository.swift
//  Stack
//
//  Created by Jessica Lin on 12/22/25.
//

import Foundation

protocol TransactionRepository {
    /// Fetches all transactions available to the current user. Later to be used to fetch from the database.
    /// Returns: An array of `Transaction` models.
    /// Throws: An error if the fetch fails (e.g. database or network error).
    func fetchTransactions() async throws -> [Transaction]
}
