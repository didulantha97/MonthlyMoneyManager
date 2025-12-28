//
//  InsightsService.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation

/// Insight recommendation for user
struct Recommendation {
    var title: String
    var message: String
    var priority: Priority
    var amount: Decimal?
    
    enum Priority {
        case high, medium, low
    }
}

/// Budget suggestion for next month
struct BudgetSuggestion {
    var categoryName: String
    var currentSpending: Decimal
    var suggestedBudget: Decimal
    var reasoning: String
}

/// Service for generating actionable insights
class InsightsService {
    
    /// Generate recommendations based on spending patterns
    static func generateRecommendations(
        transactions: [Transaction],
        budgets: [MonthlyBudget],
        categories: [Category],
        settings: AppSettings,
        monthKey: String
    ) -> [Recommendation] {
        var recommendations: [Recommendation] = []
        
        // Calculate spending by category
        let expenseTransactions = transactions.filter { $0.type == .expense }
        let spendingByCategory = Dictionary(grouping: expenseTransactions) { $0.categoryId }
            .mapValues { $0.reduce(Decimal(0)) { $0 + $1.amount } }
        
        // Check budget overruns
        for budget in budgets {
            guard let categoryName = categories.first(where: { $0.id == budget.categoryId })?.name,
                  let spent = spendingByCategory[budget.categoryId] else { continue }
            
            if spent > budget.limitAmount {
                let overspend = spent - budget.limitAmount
                recommendations.append(Recommendation(
                    title: "\(categoryName) Overspent",
                    message: "Reduce \(categoryName) by \(CurrencyFormat.formatLKR(overspend)) to meet budget",
                    priority: .high,
                    amount: overspend
                ))
            }
        }
        
        // Check cash withdrawal frequency
        if let cashCategory = categories.first(where: { $0.name == "Cash Withdrawal" }) {
            let cashTransactions = expenseTransactions.filter { $0.categoryId == cashCategory.id }
            let cashCount = cashTransactions.count
            let totalCash = cashTransactions.reduce(Decimal(0)) { $0 + $1.amount }
            
            if cashCount > 4 { // More than 4 withdrawals per month
                recommendations.append(Recommendation(
                    title: "High Cash Withdrawal Frequency",
                    message: "Limit cash withdrawals to weekly cap of \(CurrencyFormat.formatLKR(settings.weeklyCaps.cash)). Currently \(cashCount) withdrawals totaling \(CurrencyFormat.formatLKR(totalCash)).",
                    priority: .medium,
                    amount: totalCash
                ))
            }
        }
        
        // Check dining out frequency
        if let diningCategory = categories.first(where: { $0.name == "Dining Out" }) {
            let diningTransactions = expenseTransactions.filter { $0.categoryId == diningCategory.id }
            let diningCount = diningTransactions.count
            
            if diningCount > 8 { // More than 2 times per week
                recommendations.append(Recommendation(
                    title: "Frequent Dining Out",
                    message: "Consider reducing dining out frequency. Currently \(diningCount) transactions this month.",
                    priority: .medium,
                    amount: nil
                ))
            }
        }
        
        // Check grocery frequency
        if let groceryCategory = categories.first(where: { $0.name == "Groceries" }) {
            let groceryTransactions = expenseTransactions.filter { $0.categoryId == groceryCategory.id }
            let groceryCount = groceryTransactions.count
            
            if groceryCount > 12 { // More than 3 times per week
                recommendations.append(Recommendation(
                    title: "Consolidate Grocery Trips",
                    message: "Consolidate grocery trips to weekly. Currently \(groceryCount) trips this month.",
                    priority: .low,
                    amount: nil
                ))
            }
        }
        
        return recommendations.sorted { $0.priority.rawValue < $1.priority.rawValue }
    }
    
    /// Generate budget suggestions for next month
    static func generateBudgetSuggestions(
        transactions: [Transaction],
        categories: [Category],
        savingsGoal: Decimal
    ) -> [BudgetSuggestion] {
        var suggestions: [BudgetSuggestion] = []
        
        let expenseTransactions = transactions.filter { $0.type == .expense }
        let spendingByCategory = Dictionary(grouping: expenseTransactions) { $0.categoryId }
            .mapValues { $0.reduce(Decimal(0)) { $0 + $1.amount } }
        
        for (categoryId, spending) in spendingByCategory {
            guard let category = categories.first(where: { $0.id == categoryId }),
                  category.isBudgetable else { continue }
            
            // Suggest 10% reduction for variable expenses
            let reduction = category.isFixed ? Decimal(0) : spending * Decimal(0.1)
            let suggested = spending - reduction
            
            let reasoning = category.isFixed 
                ? "Fixed cost - maintain current spending"
                : "Reduce by 10% to increase savings"
            
            suggestions.append(BudgetSuggestion(
                categoryName: category.name,
                currentSpending: spending,
                suggestedBudget: suggested,
                reasoning: reasoning
            ))
        }
        
        return suggestions.sorted { $0.currentSpending > $1.currentSpending }
    }
}

extension Recommendation.Priority: Comparable {
    static func < (lhs: Recommendation.Priority, rhs: Recommendation.Priority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var rawValue: Int {
        switch self {
        case .high: return 0
        case .medium: return 1
        case .low: return 2
        }
    }
}
