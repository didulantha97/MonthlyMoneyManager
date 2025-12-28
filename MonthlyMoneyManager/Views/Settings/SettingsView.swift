//
//  SettingsView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: SettingsViewModel?
    
    var body: some View {
        NavigationView {
            Form {
                if let viewModel = viewModel {
                    Section("Currency") {
                        LabeledContent("Currency Code") {
                            Text(viewModel.settings.currencyCode)
                        }
                    }
                    
                    Section("Weekly Caps") {
                        LabeledContent("Cash Withdrawal") {
                            Text(CurrencyFormat.formatLKR(viewModel.settings.weeklyCaps.cash))
                        }
                        
                        LabeledContent("Dining Out") {
                            Text(CurrencyFormat.formatLKR(viewModel.settings.weeklyCaps.dining))
                        }
                        
                        LabeledContent("Groceries") {
                            Text(CurrencyFormat.formatLKR(viewModel.settings.weeklyCaps.groceries))
                        }
                    }
                    
                    Section("Savings Goal") {
                        LabeledContent("Monthly Target") {
                            Text(CurrencyFormat.formatLKR(viewModel.settings.savingsGoal))
                        }
                    }
                    
                    Section("Preferences") {
                        Toggle("Treat Transfers Out as Expense", isOn: Binding(
                            get: { viewModel.settings.treatTransfersOutAsExpense },
                            set: { newValue in
                                viewModel.settings.treatTransfersOutAsExpense = newValue
                                viewModel.saveSettings()
                            }
                        ))
                    }
                    
                    Section("About") {
                        LabeledContent("Version") {
                            Text("1.0.0")
                        }
                        
                        LabeledContent("Build") {
                            Text("2025.12.28")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                if viewModel == nil {
                    viewModel = SettingsViewModel(modelContext: modelContext)
                }
            }
        }
    }
}
