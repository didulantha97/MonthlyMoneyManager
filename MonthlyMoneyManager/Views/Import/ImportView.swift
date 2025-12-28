//
//  ImportView.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI
import SwiftData

struct ImportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ImportViewModel?
    
    var body: some View {
        NavigationView {
            VStack {
                if let viewModel = viewModel {
                    if !viewModel.isShowingConfirmation {
                        // Text input screen
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Paste Commercial Bank Statement Text")
                                .font(.headline)
                            
                            Text("Copy transaction history from your bank statement and paste it below. The app will automatically extract and categorize transactions.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            TextEditor(text: Binding(
                                get: { viewModel.pastedText },
                                set: { viewModel.pastedText = $0 }
                            ))
                            .frame(minHeight: 200)
                            .border(Color.gray.opacity(0.3), width: 1)
                            .cornerRadius(5)
                            
                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            
                            Button(action: { viewModel.parseText() }) {
                                Text("Parse Transactions")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .disabled(viewModel.pastedText.isEmpty)
                            
                            Spacer()
                        }
                        .padding()
                    } else {
                        // Confirmation screen
                        TransactionConfirmationView(viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("Import Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = ImportViewModel(modelContext: modelContext)
                    viewModel?.loadCategories()
                }
            }
        }
    }
}
