//
//  AppSettings.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftData

/// Weekly spending caps for specific categories
struct WeeklyCaps: Codable {
    var cash: Decimal
    var dining: Decimal
    var groceries: Decimal
    
    init(cash: Decimal = 5000, dining: Decimal = 2500, groceries: Decimal = 10000) {
        self.cash = cash
        self.dining = dining
        self.groceries = groceries
    }
}

/// Application settings and preferences
@Model
class AppSettings {
    /// Unique identifier
    var id: UUID
    
    /// Currency code (always "LKR")
    var currencyCode: String
    
    /// Weekly spending caps
    var weeklyCaps: WeeklyCaps
    
    /// Whether to treat transfer out as expense
    var treatTransfersOutAsExpense: Bool
    
    /// Monthly savings goal in LKR
    var savingsGoal: Decimal
    
    /// Whether FaceID is enabled (V2 feature)
    var enableFaceID: Bool
    
    init(
        id: UUID = UUID(),
        currencyCode: String = "LKR",
        weeklyCaps: WeeklyCaps = WeeklyCaps(),
        treatTransfersOutAsExpense: Bool = true,
        savingsGoal: Decimal = 50000,
        enableFaceID: Bool = false
    ) {
        self.id = id
        self.currencyCode = currencyCode
        self.weeklyCaps = weeklyCaps
        self.treatTransfersOutAsExpense = treatTransfersOutAsExpense
        self.savingsGoal = savingsGoal
        self.enableFaceID = enableFaceID
    }
}
