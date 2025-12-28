//
//  MonthKey.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation

/// Utility for working with month keys in format "YYYY-MM"
struct MonthKey {
    /// Generate month key from date
    static func from(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: date)
    }
    
    /// Parse month key to date (first day of month)
    static func toDate(_ monthKey: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.date(from: monthKey)
    }
    
    /// Get current month key
    static var current: String {
        from(Date())
    }
    
    /// Get display format (e.g., "December 2025")
    static func displayFormat(_ monthKey: String) -> String {
        guard let date = toDate(monthKey) else { return monthKey }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    /// Get previous month key
    static func previous(_ monthKey: String) -> String? {
        guard let date = toDate(monthKey),
              let previousDate = Calendar.current.date(byAdding: .month, value: -1, to: date) else {
            return nil
        }
        return from(previousDate)
    }
    
    /// Get next month key
    static func next(_ monthKey: String) -> String? {
        guard let date = toDate(monthKey),
              let nextDate = Calendar.current.date(byAdding: .month, value: 1, to: date) else {
            return nil
        }
        return from(nextDate)
    }
    
    /// Check if date is in specified month
    static func isDateInMonth(_ date: Date, monthKey: String) -> Bool {
        from(date) == monthKey
    }
}
