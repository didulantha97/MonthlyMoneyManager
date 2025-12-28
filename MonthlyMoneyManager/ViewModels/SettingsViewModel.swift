//
//  SettingsViewModel.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import Foundation
import SwiftData

@Observable
class SettingsViewModel {
    var settings: AppSettings
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        // Fetch or create settings
        let descriptor = FetchDescriptor<AppSettings>()
        if let existingSettings = try? modelContext.fetch(descriptor), let first = existingSettings.first {
            self.settings = first
        } else {
            self.settings = AppSettings()
            modelContext.insert(self.settings)
            try? modelContext.save()
        }
    }
    
    func saveSettings() {
        try? modelContext.save()
    }
    
    func updateWeeklyCap(cash: Decimal? = nil, dining: Decimal? = nil, groceries: Decimal? = nil) {
        if let cash = cash {
            settings.weeklyCaps.cash = cash
        }
        if let dining = dining {
            settings.weeklyCaps.dining = dining
        }
        if let groceries = groceries {
            settings.weeklyCaps.groceries = groceries
        }
        saveSettings()
    }
}
