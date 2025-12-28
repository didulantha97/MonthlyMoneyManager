//
//  MonthlyMoneyManagerApp.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI
import SwiftData

@main
struct MonthlyMoneyManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Transaction.self,
            Category.self,
            MonthlyBudget.self,
            AppSettings.self
        ])
    }
}

/// Main content view with tab navigation
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    @State private var hasSeededData = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.pie.fill")
                }
                .tag(0)
            
            TransactionsView()
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet")
                }
                .tag(1)
            
            BudgetsView()
                .tabItem {
                    Label("Budgets", systemImage: "chart.bar.fill")
                }
                .tag(2)
            
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "lightbulb.fill")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .onAppear {
            if !hasSeededData {
                DataSeeder.seedAll(modelContext: modelContext)
                hasSeededData = true
            }
        }
    }
}
