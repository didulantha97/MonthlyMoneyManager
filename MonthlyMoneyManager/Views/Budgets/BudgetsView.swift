//
//  BudgetsView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI
import SwiftData

struct BudgetsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: BudgetViewModel?
    @State private var showingSetBudget = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let viewModel = viewModel {
                    MonthYearPicker(selectedMonthKey: Binding(
                        get: { viewModel.selectedMonthKey },
                        set: { newValue in
                            viewModel.selectedMonthKey = newValue
                            viewModel.loadData()
                        }
                    ))
                    
                    if viewModel.budgetProgresses.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "chart.bar")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("No budgets set")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Button(action: { viewModel.copyFromPreviousMonth() }) {
                                Label("Copy from Previous Month", systemImage: "doc.on.doc")
                            }
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(viewModel.budgetProgresses, id: \.categoryId) { progress in
                                    BudgetCardView(progress: progress)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Budgets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingSetBudget = true }) {
                            Label("Set Budget", systemImage: "plus")
                        }
                        
                        Button(action: { viewModel?.copyFromPreviousMonth() }) {
                            Label("Copy from Previous Month", systemImage: "doc.on.doc")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingSetBudget) {
                if let viewModel = viewModel {
                    SetBudgetView(viewModel: viewModel)
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = BudgetViewModel(modelContext: modelContext)
                }
                viewModel?.loadData()
            }
        }
    }
}

struct SetBudgetView: View {
    @ObservedObject var viewModel: BudgetViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedCategoryId: UUID?
    @State private var amount = ""
    
    var availableCategories: [Category] {
        // Fetch categories from model context
        // For simplicity, we'll use empty array here
        // In real implementation, fetch from model context
        []
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Category") {
                    Picker("Category", selection: $selectedCategoryId) {
                        ForEach(availableCategories, id: \.id) { category in
                            Text(category.name).tag(category.id as UUID?)
                        }
                    }
                }
                
                Section("Budget Amount") {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Set Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveBudget()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        guard let parsedAmount = Decimal(string: amount),
              parsedAmount > 0,
              selectedCategoryId != nil else {
            return false
        }
        return true
    }
    
    private func saveBudget() {
        guard let parsedAmount = Decimal(string: amount),
              let categoryId = selectedCategoryId else {
            return
        }
        
        viewModel.setBudget(categoryId: categoryId, amount: parsedAmount)
        dismiss()
    }
}

// Make BudgetViewModel conform to ObservableObject
extension BudgetViewModel: ObservableObject {}
