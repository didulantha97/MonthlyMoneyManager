//
//  SummaryCardView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI

struct SummaryCardView: View {
    var title: String
    var amount: Decimal
    var color: Color
    var subtitle: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(CurrencyFormat.formatLKR(amount))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
