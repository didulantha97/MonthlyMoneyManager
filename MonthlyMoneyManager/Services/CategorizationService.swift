//
//  CategorizationService.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftData

/// Service for categorizing transactions based on keywords
class CategorizationService {
    
    /// Find matching category for a transaction description
    static func categorize(description: String, categories: [Category], type: TransactionType) -> Category? {
        let descUpper = description.uppercased()
        
        // Filter categories by type
        let relevantCategories = categories.filter { 
            ($0.kind == .income && type == .income) || 
            ($0.kind == .expense && type == .expense)
        }
        
        // Find first category with matching keyword
        for category in relevantCategories {
            for keyword in category.keywords {
                if descUpper.contains(keyword.uppercased()) {
                    return category
                }
            }
        }
        
        return nil
    }
    
    /// Get default category for a transaction type
    static func defaultCategory(for type: TransactionType, categories: [Category]) -> Category? {
        let relevantCategories = categories.filter { 
            ($0.kind == .income && type == .income) || 
            ($0.kind == .expense && type == .expense)
        }
        return relevantCategories.first
    }
}
