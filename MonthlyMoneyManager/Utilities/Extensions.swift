//
//  Extensions.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftUI

// MARK: - Date Extensions
extension Date {
    /// Get start of day
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// Get end of day
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    /// Get start of month
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components) ?? self
    }
    
    /// Get end of month
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth) ?? self
    }
    
    /// Check if date is in same month as another date
    func isSameMonth(as other: Date) -> Bool {
        Calendar.current.isDate(self, equalTo: other, toGranularity: .month)
    }
}

// MARK: - Decimal Extensions
extension Decimal {
    /// Convert to Double for UI purposes
    var doubleValue: Double {
        NSDecimalNumber(decimal: self).doubleValue
    }
    
    /// Check if positive
    var isPositive: Bool {
        self > 0
    }
    
    /// Check if negative
    var isNegative: Bool {
        self < 0
    }
}

// MARK: - Color Extensions
extension Color {
    /// Initialize color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - String Extensions
extension String {
    /// Trim whitespace and newlines
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
