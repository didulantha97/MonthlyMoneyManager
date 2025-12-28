//
//  CurrencyFormat.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation

/// Utility for formatting currency amounts in LKR
struct CurrencyFormat {
    /// Format amount as LKR with symbol
    static func formatLKR(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        
        let nsNumber = NSDecimalNumber(decimal: amount)
        if let formattedNumber = formatter.string(from: nsNumber) {
            return "Rs. \(formattedNumber)"
        }
        return "Rs. 0.00"
    }
    
    /// Format amount as LKR without symbol
    static func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        
        let nsNumber = NSDecimalNumber(decimal: amount)
        return formatter.string(from: nsNumber) ?? "0.00"
    }
    
    /// Parse LKR string to Decimal (handles comma separators)
    static func parseAmount(_ string: String) -> Decimal? {
        // Remove common currency symbols and whitespace
        let cleaned = string
            .replacingOccurrences(of: "Rs.", with: "")
            .replacingOccurrences(of: "LKR", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return Decimal(string: cleaned)
    }
}
