//
//  Category.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftData

/// Represents a transaction category (e.g., Salary, Groceries, Dining Out)
@Model
class Category {
    /// Unique identifier
    var id: UUID
    
    /// Category name
    var name: String
    
    /// Kind: income or expense
    var kind: CategoryKind
    
    /// Whether to include in earnings calculation
    var includeInEarnings: Bool
    
    /// Whether this category can have a budget
    var isBudgetable: Bool
    
    /// Whether this is a fixed cost (vs variable)
    var isFixed: Bool
    
    /// Keywords for auto-classification
    var keywords: [String]
    
    /// Color hex code for UI
    var colorHex: String
    
    init(
        id: UUID = UUID(),
        name: String,
        kind: CategoryKind,
        includeInEarnings: Bool = true,
        isBudgetable: Bool = false,
        isFixed: Bool = false,
        keywords: [String] = [],
        colorHex: String = "#007AFF"
    ) {
        self.id = id
        self.name = name
        self.kind = kind
        self.includeInEarnings = includeInEarnings
        self.isBudgetable = isBudgetable
        self.isFixed = isFixed
        self.keywords = keywords
        self.colorHex = colorHex
    }
}
