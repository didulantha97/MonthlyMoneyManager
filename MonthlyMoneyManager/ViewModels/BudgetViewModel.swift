//
//  BudgetViewModel.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftData

struct BudgetProgress {
    var categoryId: UUID
    var categoryName: String
    var limitAmount: Decimal
    var spentAmount: Decimal
    var remainingAmount: Decimal
    var percentageUsed: Double
    var colorHex: String
    var isFixed: Bool
}

@Observable
class BudgetViewModel {
    var selectedMonthKey: String
    var budgetProgresses: [BudgetProgress] = []
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.selectedMonthKey = MonthKey.from(Date())
    }
    
    func loadData() {
        let budgets = fetchBudgets()
        let transactions = fetchTransactions()
        let categories = fetchCategories()
        
        let categoryDict = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
        let spendingByCategory = Dictionary(grouping: transactions.filter { $0.type == .expense }) { $0.categoryId }
            .mapValues { $0.reduce(Decimal(0)) { $0 + $1.amount } }
        
        budgetProgresses = budgets.compactMap { budget in
            guard let category = categoryDict[budget.categoryId] else { return nil }
            
            let spent = spendingByCategory[budget.categoryId] ?? 0
            let remaining = budget.limitAmount - spent
            let percentage = budget.limitAmount > 0 ? (spent.doubleValue / budget.limitAmount.doubleValue) * 100 : 0
            
            return BudgetProgress(
                categoryId: budget.categoryId,
                categoryName: category.name,
                limitAmount: budget.limitAmount,
                spentAmount: spent,
                remainingAmount: remaining,
                percentageUsed: percentage,
                colorHex: category.colorHex,
                isFixed: category.isFixed
            )
        }.sorted { $0.percentageUsed > $1.percentageUsed }
    }
    
    func setBudget(categoryId: UUID, amount: Decimal) {
        // Check if budget exists
        var descriptor = FetchDescriptor<MonthlyBudget>()
        descriptor.predicate = #Predicate<MonthlyBudget> { budget in
            budget.monthKey == selectedMonthKey && budget.categoryId == categoryId
        }
        
        if let existingBudgets = try? modelContext.fetch(descriptor),
           let existingBudget = existingBudgets.first {
            existingBudget.limitAmount = amount
        } else {
            let newBudget = MonthlyBudget(
                monthKey: selectedMonthKey,
                categoryId: categoryId,
                limitAmount: amount
            )
            modelContext.insert(newBudget)
        }
        
        try? modelContext.save()
        loadData()
    }
    
    func copyFromPreviousMonth() {
        guard let previousMonthKey = MonthKey.previous(selectedMonthKey) else { return }
        
        var descriptor = FetchDescriptor<MonthlyBudget>()
        descriptor.predicate = #Predicate<MonthlyBudget> { budget in
            budget.monthKey == previousMonthKey
        }
        
        guard let previousBudgets = try? modelContext.fetch(descriptor) else { return }
        
        for previousBudget in previousBudgets {
            setBudget(categoryId: previousBudget.categoryId, amount: previousBudget.limitAmount)
        }
    }
    
    private func fetchBudgets() -> [MonthlyBudget] {
        var descriptor = FetchDescriptor<MonthlyBudget>()
        descriptor.predicate = #Predicate<MonthlyBudget> { budget in
            budget.monthKey == selectedMonthKey
        }
        return (try? modelContext.fetch(descriptor)) ?? []
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
}
