//
//  ImportParserService.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation

/// Parsed transaction from bank statement
struct ParsedTransaction {
    var date: Date
    var description: String
    var amount: Decimal
    var type: TransactionType
    var suggestedCategoryName: String
    var includeInEarnings: Bool
}

/// Service for parsing Commercial Bank transaction text
class ImportParserService {
    
    /// Parse pasted bank statement text into transactions
    static func parse(_ text: String) -> [ParsedTransaction] {
        var transactions: [ParsedTransaction] = []
        
        // Split text into lines
        let lines = text.components(separatedBy: .newlines)
        
        var currentDate: Date?
        var currentDescription = ""
        var currentAmount: Decimal?
        
        for line in lines {
            let trimmedLine = line.trimmed
            guard !trimmedLine.isEmpty else { continue }
            
            // Check if line starts with a date pattern (dd/MM/yyyy)
            if let date = extractDate(from: trimmedLine) {
                // Save previous transaction if exists
                if let date = currentDate, let amount = currentAmount, !currentDescription.isEmpty {
                    if let transaction = createTransaction(date: date, description: currentDescription, amount: amount) {
                        transactions.append(transaction)
                    }
                }
                
                // Start new transaction
                currentDate = date
                // Extract description and amount from same line or prepare for next lines
                let remainingText = trimmedLine.replacingOccurrences(of: datePattern(trimmedLine), with: "").trimmed
                currentDescription = remainingText
                currentAmount = extractAmount(from: remainingText)
            } else {
                // Continue building current transaction
                currentDescription += " " + trimmedLine
                if currentAmount == nil {
                    currentAmount = extractAmount(from: trimmedLine)
                }
            }
        }
        
        // Save last transaction
        if let date = currentDate, let amount = currentAmount, !currentDescription.isEmpty {
            if let transaction = createTransaction(date: date, description: currentDescription, amount: amount) {
                transactions.append(transaction)
            }
        }
        
        return transactions
    }
    
    /// Extract date from line (dd/MM/yyyy format)
    private static func extractDate(from line: String) -> Date? {
        let pattern = #"(\d{2})/(\d{2})/(\d{4})"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)) else {
            return nil
        }
        
        let dateString = (line as NSString).substring(with: match.range)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: dateString)
    }
    
    /// Get date pattern from line for removal
    private static func datePattern(_ line: String) -> String {
        let pattern = #"\d{2}/\d{2}/\d{4}"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)) else {
            return ""
        }
        return (line as NSString).substring(with: match.range)
    }
    
    /// Extract amount from text (handles comma separators)
    private static func extractAmount(from text: String) -> Decimal? {
        // Pattern for amounts with optional commas: 1,234.56 or 1234.56
        let pattern = #"([\d,]+\.\d{2})"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) else {
            return nil
        }
        
        let amountString = (text as NSString).substring(with: match.range)
        return CurrencyFormat.parseAmount(amountString)
    }
    
    /// Create transaction from parsed data
    private static func createTransaction(date: Date, description: String, amount: Decimal) -> ParsedTransaction? {
        guard amount > 0 else { return nil }
        
        let descUpper = description.uppercased()
        
        // Determine transaction type and category
        let (type, categoryName, includeInEarnings) = classifyTransaction(descUpper)
        
        return ParsedTransaction(
            date: date,
            description: description,
            amount: amount,
            type: type,
            suggestedCategoryName: categoryName,
            includeInEarnings: includeInEarnings
        )
    }
    
    /// Classify transaction based on description keywords
    private static func classifyTransaction(_ description: String) -> (TransactionType, String, Bool) {
        // Check for expense keywords first
        if description.contains("PURCHASE") {
            if description.contains("OPENAI") || description.contains("CHATGPT") {
                return (.expense, "Subscriptions", true)
            }
            return (.expense, "Shopping/Clothing", true)
        }
        
        if description.contains("WITHDRAWAL") || description.contains("FAST CASH") {
            return (.expense, "Cash Withdrawal", true)
        }
        
        if description.contains("PMT LOAN") {
            // Check if it's a debit (EMI) or credit (loan disbursement)
            // Since we can't determine from description alone, default to expense (EMI)
            // User can override if needed
            return (.expense, "Loan EMI", true)
        }
        
        if description.contains("CHGS") {
            return (.expense, "Bank Fees/Charges", true)
        }
        
        // Check for income keywords
        if description.contains("SALARY") || description.contains("CT0036") || description.contains("CEFTSURS") {
            return (.income, "Salary", true)
        }
        
        if description.contains("IB CEFT") && !description.contains("CHGS") {
            return (.income, "Transfer In", true)
        }
        
        if description.contains("CREDIT") {
            return (.income, "Refund/Other Income", true)
        }
        
        // Check for grocery stores
        if description.contains("KEELLS") || description.contains("CARGILLS") || 
           description.contains("FOOD MART") || description.contains("CARAVAN FRESH") {
            return (.expense, "Groceries", true)
        }
        
        // Check for dining
        if description.contains("KFC") || description.contains("PIZZA HUT") || 
           description.contains("RESTAURANT") {
            return (.expense, "Dining Out", true)
        }
        
        // Check for utilities
        if description.contains("CEB") {
            return (.expense, "Utilities", true)
        }
        
        // Check for telecom
        if description.contains("HUTCHISON") || description.contains("TELECOM") {
            return (.expense, "Telecom", true)
        }
        
        // Check for shopping/hardware
        if description.contains("TAILORS") || description.contains("TRADING") || 
           description.contains("HARDWARE") {
            return (.expense, "Shopping/Clothing", true)
        }
        
        // Check for alcohol
        if description.contains("BEER SHOP") {
            return (.expense, "Alcohol", true)
        }
        
        // Check for medical
        if description.contains("DENTAL") || description.contains("MEDICAL") {
            return (.expense, "Medical/Dental", true)
        }
        
        // Default to expense - uncategorized
        return (.expense, "Transfers Out", true)
    }
}
