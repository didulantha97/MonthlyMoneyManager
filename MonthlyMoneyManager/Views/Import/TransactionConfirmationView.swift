//
//  TransactionConfirmationView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI

struct TransactionConfirmationView: View {
    @ObservedObject var viewModel: ImportViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Review \(viewModel.parsedTransactions.count) Transactions")
                .font(.headline)
                .padding()
            
            List {
                ForEach(Array(viewModel.parsedTransactions.enumerated()), id: \.offset) { index, transaction in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(transaction.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(CurrencyFormat.formatLKR(transaction.amount))
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(transaction.type == .income ? .green : .red)
                        }
                        
                        Text(transaction.description)
                            .font(.subheadline)
                            .lineLimit(2)
                        
                        HStack {
                            Picker("Type", selection: Binding(
                                get: { transaction.type },
                                set: { newType in
                                    viewModel.updateParsedTransaction(
                                        at: index,
                                        categoryName: transaction.suggestedCategoryName,
                                        type: newType
                                    )
                                }
                            )) {
                                Text("Income").tag(TransactionType.income)
                                Text("Expense").tag(TransactionType.expense)
                            }
                            .pickerStyle(.segmented)
                            
                            Spacer()
                        }
                        
                        Picker("Category", selection: Binding(
                            get: { transaction.suggestedCategoryName },
                            set: { newCategory in
                                viewModel.updateParsedTransaction(
                                    at: index,
                                    categoryName: newCategory,
                                    type: transaction.type
                                )
                            }
                        )) {
                            ForEach(viewModel.categories.filter { 
                                ($0.kind == .income && transaction.type == .income) ||
                                ($0.kind == .expense && transaction.type == .expense)
                            }, id: \.name) { category in
                                Text(category.name).tag(category.name)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        if !transaction.includeInEarnings {
                            Text("Note: Won't be included in earnings")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(.plain)
            
            Button(action: saveTransactions) {
                Text("Save All Transactions")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
    private func saveTransactions() {
        viewModel.saveTransactions()
        dismiss()
    }
}

// Make ImportViewModel conform to ObservableObject
extension ImportViewModel: ObservableObject {}
