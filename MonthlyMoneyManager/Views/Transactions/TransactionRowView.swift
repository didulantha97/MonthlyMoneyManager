//
//  TransactionRowView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI

struct TransactionRowView: View {
    var transaction: Transaction
    var categoryName: String
    var categoryColor: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color(hex: categoryColor))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.transactionDescription)
                    .font(.body)
                    .lineLimit(1)
                
                HStack {
                    Text(categoryName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(transaction.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(CurrencyFormat.formatLKR(transaction.amount))
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(transaction.type == .income ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}
