//
//  TransactionViewModel.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftData

@Observable
class TransactionViewModel {
    var transactions: [Transaction] = []
    var categories: [Category] = []
    var selectedMonthKey: String
    var filterType: TransactionType?
    var filterCategoryId: UUID?
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.selectedMonthKey = MonthKey.from(Date())
    }
    
    func loadData() {
        loadCategories()
        loadTransactions()
    }
    
    func loadTransactions() {
        var descriptor = FetchDescriptor<Transaction>()
        
        guard let monthDate = MonthKey.toDate(selectedMonthKey) else { return }
        let startOfMonth = monthDate.startOfMonth
        let endOfMonth = monthDate.endOfMonth
        
        // Build predicate based on filters
        if let filterType = filterType, let filterCategoryId = filterCategoryId {
            descriptor.predicate = #Predicate<Transaction> { transaction in
                transaction.date >= startOfMonth && 
                transaction.date <= endOfMonth &&
                transaction.type == filterType &&
                transaction.categoryId == filterCategoryId
            }
        } else if let filterType = filterType {
            descriptor.predicate = #Predicate<Transaction> { transaction in
                transaction.date >= startOfMonth && 
                transaction.date <= endOfMonth &&
                transaction.type == filterType
            }
        } else if let filterCategoryId = filterCategoryId {
            descriptor.predicate = #Predicate<Transaction> { transaction in
                transaction.date >= startOfMonth && 
                transaction.date <= endOfMonth &&
                transaction.categoryId == filterCategoryId
            }
        } else {
            descriptor.predicate = #Predicate<Transaction> { transaction in
                transaction.date >= startOfMonth && transaction.date <= endOfMonth
            }
        }
        
        descriptor.sortBy = [SortDescriptor(\Transaction.date, order: .reverse)]
        
        transactions = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func loadCategories() {
        let descriptor = FetchDescriptor<Category>()
        categories = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func addTransaction(_ transaction: Transaction) {
        modelContext.insert(transaction)
        try? modelContext.save()
        loadTransactions()
    }
    
    func updateTransaction(_ transaction: Transaction) {
        try? modelContext.save()
        loadTransactions()
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        modelContext.delete(transaction)
        try? modelContext.save()
        loadTransactions()
    }
    
    func getCategoryName(for categoryId: UUID) -> String {
        categories.first { $0.id == categoryId }?.name ?? "Unknown"
    }
    
    func getCategoryColor(for categoryId: UUID) -> String {
        categories.first { $0.id == categoryId }?.colorHex ?? "#007AFF"
    }
}
