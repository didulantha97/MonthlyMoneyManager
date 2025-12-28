//
//  AddTransactionView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI

struct AddTransactionView: View {
    @ObservedObject var viewModel: TransactionViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var date = Date()
    @State private var amount = ""
    @State private var description = ""
    @State private var type: TransactionType = .expense
    @State private var selectedCategoryId: UUID?
    
    var filteredCategories: [Category] {
        viewModel.categories.filter { 
            ($0.kind == .income && type == .income) || 
            ($0.kind == .expense && type == .expense)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Transaction Details") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    TextField("Description", text: $description)
                }
                
                Section("Type") {
                    Picker("Type", selection: $type) {
                        Text("Income").tag(TransactionType.income)
                        Text("Expense").tag(TransactionType.expense)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: type) { _, _ in
                        selectedCategoryId = filteredCategories.first?.id
                    }
                }
                
                Section("Category") {
                    Picker("Category", selection: $selectedCategoryId) {
                        ForEach(filteredCategories, id: \.id) { category in
                            Text(category.name).tag(category.id as UUID?)
                        }
                    }
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTransaction()
                    }
                    .disabled(!isValid)
                }
            }
            .onAppear {
                selectedCategoryId = filteredCategories.first?.id
            }
        }
    }
    
    private var isValid: Bool {
        guard let parsedAmount = Decimal(string: amount),
              parsedAmount > 0,
              !description.isEmpty,
              selectedCategoryId != nil else {
            return false
        }
        return true
    }
    
    private func saveTransaction() {
        guard let parsedAmount = Decimal(string: amount),
              let categoryId = selectedCategoryId else {
            return
        }
        
        let transaction = Transaction(
            date: date,
            amount: parsedAmount,
            type: type,
            description: description,
            categoryId: categoryId
        )
        
        viewModel.addTransaction(transaction)
        dismiss()
    }
}
