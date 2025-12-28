//
//  ImportViewModel.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftData

@Observable
class ImportViewModel {
    var pastedText: String = ""
    var parsedTransactions: [ParsedTransaction] = []
    var categories: [Category] = []
    var isShowingConfirmation: Bool = false
    var errorMessage: String?
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadCategories() {
        let descriptor = FetchDescriptor<Category>()
        categories = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func parseText() {
        errorMessage = nil
        parsedTransactions.removeAll()
        
        guard !pastedText.isEmpty else {
            errorMessage = "Please paste transaction text"
            return
        }
        
        parsedTransactions = ImportParserService.parse(pastedText)
        
        if parsedTransactions.isEmpty {
            errorMessage = "No transactions found in pasted text"
        } else {
            isShowingConfirmation = true
        }
    }
    
    func saveTransactions() {
        for parsed in parsedTransactions {
            // Find category by name
            guard let category = categories.first(where: { $0.name == parsed.suggestedCategoryName }) else {
                continue
            }
            
            let transaction = Transaction(
                date: parsed.date,
                amount: parsed.amount,
                type: parsed.type,
                description: parsed.description,
                categoryId: category.id,
                includeInEarnings: parsed.includeInEarnings,
                source: .imported
            )
            
            modelContext.insert(transaction)
        }
        
        try? modelContext.save()
        
        // Reset state
        pastedText = ""
        parsedTransactions.removeAll()
        isShowingConfirmation = false
    }
    
    func updateParsedTransaction(at index: Int, categoryName: String, type: TransactionType) {
        guard index < parsedTransactions.count else { return }
        parsedTransactions[index].suggestedCategoryName = categoryName
        parsedTransactions[index].type = type
        
        // Update includeInEarnings based on category
        if categoryName == "Loan Credit" {
            parsedTransactions[index].includeInEarnings = false
        }
    }
}
