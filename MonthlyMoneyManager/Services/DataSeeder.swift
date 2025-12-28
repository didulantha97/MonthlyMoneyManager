//
//  DataSeeder.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftData

/// Service for seeding initial data
class DataSeeder {
    
    /// Seed default categories
    static func seedCategories(modelContext: ModelContext) {
        // Check if categories already exist
        let descriptor = FetchDescriptor<Category>()
        if let existingCategories = try? modelContext.fetch(descriptor), !existingCategories.isEmpty {
            return // Already seeded
        }
        
        // Income categories
        let incomeCategories = [
            Category(
                name: "Salary",
                kind: .income,
                includeInEarnings: true,
                isBudgetable: false,
                isFixed: false,
                keywords: ["SALARY", "CT0036", "CEFTSURS"],
                colorHex: "#34C759"
            ),
            Category(
                name: "Transfer In",
                kind: .income,
                includeInEarnings: true,
                isBudgetable: false,
                isFixed: false,
                keywords: ["IB CEFT"],
                colorHex: "#30D158"
            ),
            Category(
                name: "Refund/Other Income",
                kind: .income,
                includeInEarnings: true,
                isBudgetable: false,
                isFixed: false,
                keywords: ["CREDIT", "REFUND"],
                colorHex: "#32D74B"
            ),
            Category(
                name: "Loan Credit",
                kind: .income,
                includeInEarnings: false,
                isBudgetable: false,
                isFixed: false,
                keywords: ["PMT LOAN"],
                colorHex: "#FF9500"
            )
        ]
        
        // Expense categories
        let expenseCategories = [
            Category(
                name: "Loan EMI",
                kind: .expense,
                includeInEarnings: true,
                isBudgetable: false,
                isFixed: true,
                keywords: ["PMT LOAN"],
                colorHex: "#FF3B30"
            ),
            Category(
                name: "Groceries",
                kind: .expense,
                includeInEarnings: true,
                isBudgetable: true,
                isFixed: false,
                keywords: ["KEELLS", "CARGILLS", "FOOD MART", "CARAVAN FRESH"],
                colorHex: "#FF9500"
            ),
            Category(
                name: "Dining Out",
                kind: .expense,
                includeInEarnings: true,
                isBudgetable: true,
                isFixed: false,
                keywords: ["KFC", "PIZZA HUT", "RESTAURANT"],
                colorHex: "#FF2D55"
            ),
            Category(
                name: "Cash Withdrawal",
                kind: .expense,
                includeInEarnings: true,
                isBudgetable: true,
                isFixed: false,
                keywords: ["FAST CASH", "WITHDRAWAL"],
                colorHex: "#5AC8FA"
            ),
            Category(
                name: "Utilities",
                kind: .expense,
                includeInEarnings: true,
                isBudgetable: true,
                isFixed: true,
                keywords: ["CEB"],
                colorHex: "#FFCC00"
            ),
            Category(
                name: "Telecom",
                kind: .expense,
                includeInEarnings: true,
                isBudgetable: true,
                isFixed: true,
                keywords: ["HUTCHISON", "TELECOM"],
                colorHex: "#5856D6"
            ),
            Category(
                name: "Subscriptions",
                kind: .expense,
                includeInEarnings: true,
                isBudgetable: true,
                isFixed: true,
                keywords: ["OPENAI", "CHATGPT", "SUBSCRIPTION"],
                colorHex: "#AF52DE"
            ),
            Category(
                name: "Shopping/Clothing",
                kind: .expense,
                includeInEarnings: true,
                isBudgetable: true,
                isFixed: false,
                keywords: ["TAILORS", "TRADING", "HARDWARE"],
                colorHex: "#FF6482"
            ),
            Category(
                name: "Bank Fees/Charges",
                kind: .expense,
                includeInEarnings: true,
                isBudgetable: false,
                isFixed: false,
                keywords: ["CHGS"],
                colorHex: "#8E8E93"
            ),
            Category(
                name: "Alcohol",
                kind: .expense,
                includeInEarnings: true,
                isBudgetable: true,
                isFixed: false,
                keywords: ["BEER SHOP", "WINE", "LIQUOR"],
                colorHex: "#BF5AF2"
            ),
            Category(
                name: "Medical/Dental",
                kind: .expense,
                includeInEarnings: true,
                isBudgetable: true,
                isFixed: false,
                keywords: ["DENTAL", "MEDICAL", "HOSPITAL"],
                colorHex: "#FF375F"
            ),
            Category(
                name: "Transfers Out",
                kind: .expense,
                includeInEarnings: true,
                isBudgetable: false,
                isFixed: false,
                keywords: [],
                colorHex: "#007AFF"
            )
        ]
        
        // Insert all categories
        for category in incomeCategories + expenseCategories {
            modelContext.insert(category)
        }
        
        try? modelContext.save()
    }
    
    /// Seed sample transactions for December 2025
    static func seedSampleTransactions(modelContext: ModelContext) {
        // Check if transactions already exist
        let descriptor = FetchDescriptor<Transaction>()
        if let existingTransactions = try? modelContext.fetch(descriptor), !existingTransactions.isEmpty {
            return // Already seeded
        }
        
        // Get categories
        guard let categories = try? modelContext.fetch(FetchDescriptor<Category>()) else { return }
        
        func getCategoryId(name: String) -> UUID? {
            categories.first { $0.name == name }?.id
        }
        
        // Create date for December 2025
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2025
        dateComponents.month = 12
        
        // Helper function to create date
        func date(day: Int) -> Date {
            dateComponents.day = day
            return calendar.date(from: dateComponents) ?? Date()
        }
        
        // Income transactions
        if let salaryId = getCategoryId(name: "Salary") {
            modelContext.insert(Transaction(
                date: date(day: 1),
                amount: 150000,
                type: .income,
                description: "SALARY CT0036 COMPANY NAME",
                categoryId: salaryId,
                includeInEarnings: true,
                source: .manual
            ))
        }
        
        if let loanCreditId = getCategoryId(name: "Loan Credit") {
            modelContext.insert(Transaction(
                date: date(day: 5),
                amount: 500000,
                type: .income,
                description: "PMT LOAN 4873937 DISBURSEMENT",
                categoryId: loanCreditId,
                includeInEarnings: false,
                source: .manual
            ))
        }
        
        // Expense transactions
        if let subscriptionId = getCategoryId(name: "Subscriptions") {
            modelContext.insert(Transaction(
                date: date(day: 3),
                amount: 6409.77,
                type: .expense,
                description: "PURCHASE OPENAI *CHATGPT SUB",
                categoryId: subscriptionId,
                source: .manual
            ))
        }
        
        if let groceryId = getCategoryId(name: "Groceries") {
            // Multiple grocery transactions
            modelContext.insert(Transaction(
                date: date(day: 7),
                amount: 8500,
                type: .expense,
                description: "PURCHASE KEELLS SUPER COLOMBO",
                categoryId: groceryId,
                source: .manual
            ))
            
            modelContext.insert(Transaction(
                date: date(day: 12),
                amount: 7200,
                type: .expense,
                description: "PURCHASE KEELLS SUPER COLOMBO",
                categoryId: groceryId,
                source: .manual
            ))
            
            modelContext.insert(Transaction(
                date: date(day: 18),
                amount: 9300,
                type: .expense,
                description: "PURCHASE CARGILLS FOOD CITY",
                categoryId: groceryId,
                source: .manual
            ))
        }
        
        if let diningId = getCategoryId(name: "Dining Out") {
            modelContext.insert(Transaction(
                date: date(day: 10),
                amount: 3200,
                type: .expense,
                description: "PURCHASE KFC COLOMBO",
                categoryId: diningId,
                source: .manual
            ))
            
            modelContext.insert(Transaction(
                date: date(day: 15),
                amount: 4500,
                type: .expense,
                description: "PURCHASE PIZZA HUT NUGEGODA",
                categoryId: diningId,
                source: .manual
            ))
            
            modelContext.insert(Transaction(
                date: date(day: 20),
                amount: 5800,
                type: .expense,
                description: "PURCHASE RESTAURANT COLOMBO",
                categoryId: diningId,
                source: .manual
            ))
        }
        
        if let cashId = getCategoryId(name: "Cash Withdrawal") {
            modelContext.insert(Transaction(
                date: date(day: 8),
                amount: 10000,
                type: .expense,
                description: "FAST CASH KADAWATH-CRM1 BR",
                categoryId: cashId,
                source: .manual
            ))
            
            modelContext.insert(Transaction(
                date: date(day: 16),
                amount: 10000,
                type: .expense,
                description: "WITHDRAWAL KADAWATHA-1 BR",
                categoryId: cashId,
                source: .manual
            ))
            
            modelContext.insert(Transaction(
                date: date(day: 23),
                amount: 10000,
                type: .expense,
                description: "FAST CASH COLOMBO-2 BR",
                categoryId: cashId,
                source: .manual
            ))
        }
        
        if let utilityId = getCategoryId(name: "Utilities") {
            modelContext.insert(Transaction(
                date: date(day: 11),
                amount: 5500,
                type: .expense,
                description: "BILL PMT CEB ELECTRICITY",
                categoryId: utilityId,
                source: .manual
            ))
        }
        
        if let telecomId = getCategoryId(name: "Telecom") {
            modelContext.insert(Transaction(
                date: date(day: 14),
                amount: 1500,
                type: .expense,
                description: "BILL PMT HUTCHISON TELECOM",
                categoryId: telecomId,
                source: .manual
            ))
        }
        
        if let loanEMIId = getCategoryId(name: "Loan EMI") {
            modelContext.insert(Transaction(
                date: date(day: 2),
                amount: 102533,
                type: .expense,
                description: "PMT LOAN 4873937 3508386",
                categoryId: loanEMIId,
                source: .manual
            ))
        }
        
        if let feesId = getCategoryId(name: "Bank Fees/Charges") {
            modelContext.insert(Transaction(
                date: date(day: 25),
                amount: 25,
                type: .expense,
                description: "IB CEFT CHGS TRANSFER FEE",
                categoryId: feesId,
                source: .manual
            ))
        }
        
        try? modelContext.save()
    }
    
    /// Seed sample budgets for December 2025
    static func seedSampleBudgets(modelContext: ModelContext) {
        let monthKey = "2025-12"
        
        // Check if budgets already exist
        let descriptor = FetchDescriptor<MonthlyBudget>()
        if let existingBudgets = try? modelContext.fetch(descriptor), !existingBudgets.isEmpty {
            return // Already seeded
        }
        
        // Get categories
        guard let categories = try? modelContext.fetch(FetchDescriptor<Category>()) else { return }
        
        let budgetData: [(String, Decimal)] = [
            ("Dining Out", 10000),
            ("Groceries", 40000),
            ("Cash Withdrawal", 20000),
            ("Utilities", 6000),
            ("Telecom", 2000),
            ("Subscriptions", 7000)
        ]
        
        for (categoryName, amount) in budgetData {
            if let category = categories.first(where: { $0.name == categoryName }) {
                modelContext.insert(MonthlyBudget(
                    monthKey: monthKey,
                    categoryId: category.id,
                    limitAmount: amount
                ))
            }
        }
        
        try? modelContext.save()
    }
    
    /// Seed default app settings
    static func seedAppSettings(modelContext: ModelContext) {
        // Check if settings already exist
        let descriptor = FetchDescriptor<AppSettings>()
        if let existingSettings = try? modelContext.fetch(descriptor), !existingSettings.isEmpty {
            return // Already seeded
        }
        
        let settings = AppSettings()
        modelContext.insert(settings)
        try? modelContext.save()
    }
    
    /// Seed all data
    static func seedAll(modelContext: ModelContext) {
        seedCategories(modelContext: modelContext)
        seedSampleTransactions(modelContext: modelContext)
        seedSampleBudgets(modelContext: modelContext)
        seedAppSettings(modelContext: modelContext)
    }
}
