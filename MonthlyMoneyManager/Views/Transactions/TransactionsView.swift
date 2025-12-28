//
//  TransactionsView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: TransactionViewModel?
    @State private var showingAddTransaction = false
    @State private var showingImport = false
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let viewModel = viewModel {
                    MonthYearPicker(selectedMonthKey: Binding(
                        get: { viewModel.selectedMonthKey },
                        set: { newValue in
                            viewModel.selectedMonthKey = newValue
                            viewModel.loadTransactions()
                        }
                    ))
                    
                    // Filter buttons
                    HStack {
                        Button(action: { showingFilters.toggle() }) {
                            Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
                        }
                        
                        Spacer()
                        
                        if viewModel.filterType != nil || viewModel.filterCategoryId != nil {
                            Button("Clear") {
                                viewModel.filterType = nil
                                viewModel.filterCategoryId = nil
                                viewModel.loadTransactions()
                            }
                            .foregroundColor(.orange)
                        }
                    }
                    .padding(.horizontal)
                    
                    if viewModel.transactions.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "tray")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("No transactions")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(viewModel.transactions, id: \.id) { transaction in
                                NavigationLink(destination: TransactionDetailView(
                                    transaction: transaction,
                                    viewModel: viewModel
                                )) {
                                    TransactionRowView(
                                        transaction: transaction,
                                        categoryName: viewModel.getCategoryName(for: transaction.categoryId),
                                        categoryColor: viewModel.getCategoryColor(for: transaction.categoryId)
                                    )
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    viewModel.deleteTransaction(viewModel.transactions[index])
                                }
                            }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            viewModel.loadTransactions()
                        }
                    }
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingAddTransaction = true }) {
                            Label("Add Manual", systemImage: "plus")
                        }
                        
                        Button(action: { showingImport = true }) {
                            Label("Import from Bank", systemImage: "square.and.arrow.down")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                if let viewModel = viewModel {
                    AddTransactionView(viewModel: viewModel)
                }
            }
            .sheet(isPresented: $showingImport) {
                ImportView()
                    .environment(\.modelContext, modelContext)
            }
            .sheet(isPresented: $showingFilters) {
                if let viewModel = viewModel {
                    FilterView(viewModel: viewModel)
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = TransactionViewModel(modelContext: modelContext)
                }
                viewModel?.loadData()
            }
        }
    }
}

struct FilterView: View {
    @ObservedObject var viewModel: TransactionViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Type") {
                    Picker("Type", selection: Binding(
                        get: { viewModel.filterType },
                        set: { viewModel.filterType = $0 }
                    )) {
                        Text("All").tag(nil as TransactionType?)
                        Text("Income").tag(TransactionType.income as TransactionType?)
                        Text("Expense").tag(TransactionType.expense as TransactionType?)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Category") {
                    Picker("Category", selection: Binding(
                        get: { viewModel.filterCategoryId },
                        set: { viewModel.filterCategoryId = $0 }
                    )) {
                        Text("All Categories").tag(nil as UUID?)
                        ForEach(viewModel.categories, id: \.id) { category in
                            Text(category.name).tag(category.id as UUID?)
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        viewModel.loadTransactions()
                        dismiss()
                    }
                }
            }
        }
    }
}

// Make TransactionViewModel conform to ObservableObject for FilterView
extension TransactionViewModel: ObservableObject {}
