//
//  DashboardViewModel.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftData

@Observable
class DashboardViewModel {
    var selectedMonthKey: String
    var realIncome: Decimal = 0
    var totalOutflow: Decimal = 0
    var savings: Decimal = 0
    var savingsRate: Double = 0
    var fixedCosts: Decimal = 0
    var variableCosts: Decimal = 0
    var warnings: [String] = []
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.selectedMonthKey = MonthKey.from(Date())
    }
    
    func loadData() {
        let transactions = fetchTransactions()
        let categories = fetchCategories()
        
        // Calculate real income (excluding loan credits)
        realIncome = transactions
            .filter { $0.type == .income && $0.includeInEarnings }
            .reduce(Decimal(0)) { $0 + $1.amount }
        
        // Calculate total outflow
        totalOutflow = transactions
            .filter { $0.type == .expense }
            .reduce(Decimal(0)) { $0 + $1.amount }
        
        // Calculate savings
        savings = realIncome - totalOutflow
        
        // Calculate savings rate
        if realIncome > 0 {
            savingsRate = (savings.doubleValue / realIncome.doubleValue) * 100
        } else {
            savingsRate = 0
        }
        
        // Calculate fixed vs variable costs
        let categoryDict = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
        
        fixedCosts = transactions
            .filter { $0.type == .expense }
            .filter { categoryDict[$0.categoryId]?.isFixed == true }
            .reduce(Decimal(0)) { $0 + $1.amount }
        
        variableCosts = totalOutflow - fixedCosts
        
        // Generate warnings
        generateWarnings(transactions: transactions, categories: categories)
    }
    
    private func generateWarnings(transactions: [Transaction], categories: [Category]) {
        warnings.removeAll()
        
        // Check for loan credits
        let hasLoanCredit = transactions.contains { 
            $0.type == .income && !$0.includeInEarnings 
        }
        if hasLoanCredit {
            warnings.append("Loan credit excluded from earnings")
        }
        
        // Check budget overruns
        let budgets = fetchBudgets()
        let categoryDict = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
        let spendingByCategory = Dictionary(grouping: transactions.filter { $0.type == .expense }) { $0.categoryId }
            .mapValues { $0.reduce(Decimal(0)) { $0 + $1.amount } }
        
        for budget in budgets {
            if let spent = spendingByCategory[budget.categoryId],
               spent > budget.limitAmount,
               let categoryName = categoryDict[budget.categoryId]?.name {
                let overspend = spent - budget.limitAmount
                warnings.append("\(categoryName) overspent by \(CurrencyFormat.formatLKR(overspend))")
            }
        }
        
        // Check cash withdrawal
        if let cashCategory = categories.first(where: { $0.name == "Cash Withdrawal" }) {
            let cashTotal = spendingByCategory[cashCategory.id] ?? 0
            if cashTotal > 25000 {
                warnings.append("Cash withdrawal high—risk of leakage")
            }
        }
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
}
