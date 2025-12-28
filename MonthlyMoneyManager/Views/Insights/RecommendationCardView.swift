//
//  RecommendationCardView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI

struct RecommendationCardView: View {
    var recommendation: Recommendation
    
    var priorityColor: Color {
        switch recommendation.priority {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .blue
        }
    }
    
    var priorityIcon: String {
        switch recommendation.priority {
        case .high:
            return "exclamationmark.triangle.fill"
        case .medium:
            return "exclamationmark.circle.fill"
        case .low:
            return "info.circle.fill"
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: priorityIcon)
                .foregroundColor(priorityColor)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(recommendation.title)
                    .font(.headline)
                
                Text(recommendation.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(priorityColor.opacity(0.1))
        .cornerRadius(10)
    }
}
