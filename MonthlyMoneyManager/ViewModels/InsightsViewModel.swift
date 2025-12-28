//
//  InsightsViewModel.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftData

@Observable
class InsightsViewModel {
    var selectedMonthKey: String
    var recommendations: [Recommendation] = []
    var budgetSuggestions: [BudgetSuggestion] = []
    var topSpendingCategories: [(name: String, amount: Decimal, color: String)] = []
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.selectedMonthKey = MonthKey.from(Date())
    }
    
    func loadData() {
        let transactions = fetchTransactions()
        let categories = fetchCategories()
        let budgets = fetchBudgets()
        let settings = fetchSettings()
        
        // Generate recommendations
        recommendations = InsightsService.generateRecommendations(
            transactions: transactions,
            budgets: budgets,
            categories: categories,
            settings: settings,
            monthKey: selectedMonthKey
        )
        
        // Generate budget suggestions for next month
        budgetSuggestions = InsightsService.generateBudgetSuggestions(
            transactions: transactions,
            categories: categories,
            savingsGoal: settings.savingsGoal
        )
        
        // Calculate top spending categories
        calculateTopSpending(transactions: transactions, categories: categories)
    }
    
    private func calculateTopSpending(transactions: [Transaction], categories: [Category]) {
        let categoryDict = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
        let spendingByCategory = Dictionary(grouping: transactions.filter { $0.type == .expense }) { $0.categoryId }
            .mapValues { $0.reduce(Decimal(0)) { $0 + $1.amount } }
        
        topSpendingCategories = spendingByCategory
            .compactMap { (categoryId, amount) -> (name: String, amount: Decimal, color: String)? in
                guard let category = categoryDict[categoryId] else { return nil }
                return (category.name, amount, category.colorHex)
            }
            .sorted { $0.amount > $1.amount }
            .prefix(5)
            .map { $0 }
    }
    
    private func fetchTransactions() -> [Transaction] {
        var descriptor = FetchDescriptor<Transaction>()
        
        guard let monthDate = MonthKey.toDate(selectedMonthKey) else { return [] }
        let startOfMonth = monthDate.startOfMonth
        let endOfMonth = monthDate.endOfMonth
        
        descriptor.predicate = #Predicate<Transaction> { transaction in
            transaction.date >= startOfMonth && transaction.date <= endOfMonth
        }
        
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    private func fetchCategories() -> [Category] {
        let descriptor = FetchDescriptor<Category>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    private func fetchBudgets() -> [MonthlyBudget] {
        var descriptor = FetchDescriptor<MonthlyBudget>()
        descriptor.predicate = #Predicate<MonthlyBudget> { budget in
            budget.monthKey == selectedMonthKey
        }
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    private func fetchSettings() -> AppSettings {
        let descriptor = FetchDescriptor<AppSettings>()
        return (try? modelContext.fetch(descriptor))?.first ?? AppSettings()
    }
}
