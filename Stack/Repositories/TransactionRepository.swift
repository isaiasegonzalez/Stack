//
//  TransactionRepository.swift
//  Stack
//
//  Created by Jessica Lin on 12/22/25.
//

import Foundation

protocol TransactionRepository {
    func fetchTransactions() async throws -> [Transaction]
}
