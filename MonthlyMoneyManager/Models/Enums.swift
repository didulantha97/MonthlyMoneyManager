//
//  Enums.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation

/// Type of transaction: income or expense
enum TransactionType: String, Codable, CaseIterable {
    case income = "Income"
    case expense = "Expense"
}

/// Category kind: income or expense
enum CategoryKind: String, Codable, CaseIterable {
    case income = "Income"
    case expense = "Expense"
}

/// Source of transaction: manual entry or imported from bank statement
enum TransactionSource: String, Codable, CaseIterable {
    case manual = "Manual"
    case imported = "Import"
}
