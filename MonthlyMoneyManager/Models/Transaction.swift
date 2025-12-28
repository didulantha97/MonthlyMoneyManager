//
//  Transaction.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftData

/// Represents a single financial transaction (income or expense)
@Model
class Transaction {
    /// Unique identifier
    var id: UUID
    
    /// Date of transaction
    var date: Date
    
    /// Amount in LKR
    var amount: Decimal
    
    /// Type: income or expense
    var type: TransactionType
    
    /// Description or note
    var transactionDescription: String
    
    /// Reference to category
    var categoryId: UUID
    
    /// Whether to include in earnings calculation (false for loan credits)
    var includeInEarnings: Bool
    
    /// Source: manual or imported
    var source: TransactionSource
    
    /// Created timestamp
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        date: Date,
        amount: Decimal,
        type: TransactionType,
        description: String,
        categoryId: UUID,
        includeInEarnings: Bool = true,
        source: TransactionSource = .manual,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.date = date
        self.amount = amount
        self.type = type
        self.transactionDescription = description
        self.categoryId = categoryId
        self.includeInEarnings = includeInEarnings
        self.source = source
        self.createdAt = createdAt
    }
}
