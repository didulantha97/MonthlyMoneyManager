//
//  NextMonthPlanView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI

struct NextMonthPlanView: View {
    var suggestions: [BudgetSuggestion]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Next Month Budget Suggestions")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(Array(suggestions.enumerated()), id: \.offset) { _, suggestion in
                VStack(alignment: .leading, spacing: 8) {
                    Text(suggestion.categoryName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Current")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(CurrencyFormat.formatLKR(suggestion.currentSpending))
                                .font(.caption)
                        }
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        VStack(alignment: .leading) {
                            Text("Suggested")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(CurrencyFormat.formatLKR(suggestion.suggestedBudget))
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Text(suggestion.reasoning)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }
}
