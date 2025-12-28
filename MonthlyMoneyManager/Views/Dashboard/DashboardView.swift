//
//  DashboardView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: DashboardViewModel?
    
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
                        
                        // Summary Cards
                        VStack(spacing: 15) {
                            SummaryCardView(
                                title: "Real Income",
                                amount: viewModel.realIncome,
                                color: .green
                            )
                            
                            SummaryCardView(
                                title: "Total Outflow",
                                amount: viewModel.totalOutflow,
                                color: .red
                            )
                            
                            SummaryCardView(
                                title: "Savings",
                                amount: viewModel.savings,
                                color: viewModel.savings >= 0 ? .blue : .orange,
                                subtitle: String(format: "%.1f%% savings rate", viewModel.savingsRate)
                            )
                        }
                        .padding(.horizontal)
                        
                        // Fixed vs Variable
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Cost Breakdown")
                                .font(.headline)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Fixed Costs")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(CurrencyFormat.formatLKR(viewModel.fixedCosts))
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Variable Costs")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(CurrencyFormat.formatLKR(viewModel.variableCosts))
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Warnings
                        if !viewModel.warnings.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Alerts")
                                    .font(.headline)
                                
                                ForEach(viewModel.warnings, id: \.self) { warning in
                                    HStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.orange)
                                        Text(warning)
                                            .font(.subheadline)
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Dashboard")
            .onAppear {
                if viewModel == nil {
                    viewModel = DashboardViewModel(modelContext: modelContext)
                }
                viewModel?.loadData()
            }
        }
    }
}
