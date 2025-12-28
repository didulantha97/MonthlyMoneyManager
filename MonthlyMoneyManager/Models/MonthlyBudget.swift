//
//  MonthlyBudget.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftData

/// Represents a budget limit for a specific category in a specific month
@Model
class MonthlyBudget {
    /// Unique identifier
    var id: UUID
    
    /// Month key in format "YYYY-MM"
    var monthKey: String
    
    /// Reference to category
    var categoryId: UUID
    
    /// Budget limit amount in LKR
    var limitAmount: Decimal
    
    init(
        id: UUID = UUID(),
        monthKey: String,
        categoryId: UUID,
        limitAmount: Decimal
    ) {
        self.id = id
        self.monthKey = monthKey
        self.categoryId = categoryId
        self.limitAmount = limitAmount
    }
}
