//
//  TransactionDetailView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI

struct TransactionDetailView: View {
    var transaction: Transaction
    var viewModel: TransactionViewModel?
    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = false
    
    var body: some View {
        Form {
            Section("Details") {
                LabeledContent("Date") {
                    Text(transaction.date, style: .date)
                }
                
                LabeledContent("Amount") {
                    Text(CurrencyFormat.formatLKR(transaction.amount))
                        .foregroundColor(transaction.type == .income ? .green : .red)
                }
                
                LabeledContent("Type") {
                    Text(transaction.type.rawValue)
                }
                
                LabeledContent("Category") {
                    Text(viewModel?.getCategoryName(for: transaction.categoryId) ?? "Unknown")
                }
                
                LabeledContent("Source") {
                    Text(transaction.source.rawValue)
                }
                
                if !transaction.includeInEarnings && transaction.type == .income {
                    LabeledContent("Include in Earnings") {
                        Text("No")
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Section("Description") {
                Text(transaction.transactionDescription)
            }
            
            Section {
                Button(role: .destructive, action: deleteTransaction) {
                    Label("Delete Transaction", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Transaction")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func deleteTransaction() {
        viewModel?.deleteTransaction(transaction)
        dismiss()
    }
}
