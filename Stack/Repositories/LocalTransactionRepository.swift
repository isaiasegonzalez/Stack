//
//  LocalTransactionRepository.swift
//  Stack
//
//  Created by Jessica Lin on 12/22/25.
//

import Foundation
import SwiftData

final class LocalTransactionRepository: TransactionRepository {
    private let context: ModelContext
    init (context: ModelContext) {
        self.context = context
    }
    
    func fetchTransactions() async throws -> [Transaction] {
        let descriptor = FetchDescriptor<Transaction>(
                    sortBy: [SortDescriptor(\.date, order: .reverse)]
                )
                return try context.fetch(descriptor)
    }
    
}
