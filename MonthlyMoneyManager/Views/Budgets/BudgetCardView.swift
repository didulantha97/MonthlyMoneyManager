//
//  BudgetCardView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI

struct BudgetCardView: View {
    var progress: BudgetProgress
    
    var progressColor: Color {
        if progress.percentageUsed >= 100 {
            return .red
        } else if progress.percentageUsed >= 80 {
            return .orange
        } else {
            return .green
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(progress.categoryName)
                    .font(.headline)
                
                Spacer()
                
                if progress.isFixed {
                    Text("Fixed")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(5)
                }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Spent")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(CurrencyFormat.formatLKR(progress.spentAmount))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Budget")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(CurrencyFormat.formatLKR(progress.limitAmount))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            
            ProgressBar(
                value: min(progress.percentageUsed / 100, 1.0),
                color: progressColor,
                height: 12
            )
            
            HStack {
                Text(String(format: "%.1f%% used", progress.percentageUsed))
                    .font(.caption)
                    .foregroundColor(progressColor)
                
                Spacer()
                
                if progress.remainingAmount >= 0 {
                    Text("\(CurrencyFormat.formatLKR(progress.remainingAmount)) remaining")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("\(CurrencyFormat.formatLKR(abs(progress.remainingAmount))) over budget")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
