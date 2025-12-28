//
//  InsightsView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI
import SwiftData

struct InsightsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: InsightsViewModel?
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let viewModel = viewModel {
                    VStack(spacing: 20) {
                        MonthYearPicker(selectedMonthKey: Binding(
                            get: { viewModel.selectedMonthKey },
                            set: { newValue in
                                viewModel.selectedMonthKey = newValue
                                viewModel.loadData()
                            }
                        ))
                        
                        // Top Spending Categories
                        if !viewModel.topSpendingCategories.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Top Spending Categories")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ForEach(Array(viewModel.topSpendingCategories.enumerated()), id: \.offset) { index, category in
                                    HStack {
                                        Text("\(index + 1).")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                            .frame(width: 30)
                                        
                                        Circle()
                                            .fill(Color(hex: category.color))
                                            .frame(width: 12, height: 12)
                                        
                                        Text(category.name)
                                            .font(.body)
                                        
                                        Spacer()
                                        
                                        Text(CurrencyFormat.formatLKR(category.amount))
                                            .font(.body)
                                            .fontWeight(.semibold)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                        // Recommendations
                        if !viewModel.recommendations.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Recommendations")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ForEach(Array(viewModel.recommendations.enumerated()), id: \.offset) { _, recommendation in
                                    RecommendationCardView(recommendation: recommendation)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Next Month Plan
                        if !viewModel.budgetSuggestions.isEmpty {
                            NextMonthPlanView(suggestions: viewModel.budgetSuggestions)
                        }
                    }
                    .padding(.vertical)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Insights")
            .onAppear {
                if viewModel == nil {
                    viewModel = InsightsViewModel(modelContext: modelContext)
                }
                viewModel?.loadData()
            }
        }
    }
}
