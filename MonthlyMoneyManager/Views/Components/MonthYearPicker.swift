//
//  MonthYearPicker.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI

struct MonthYearPicker: View {
    @Binding var selectedMonthKey: String
    
    var body: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.title2)
            }
            
            Spacer()
            
            Text(MonthKey.displayFormat(selectedMonthKey))
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.title2)
            }
        }
        .padding()
    }
    
    private func previousMonth() {
        if let prev = MonthKey.previous(selectedMonthKey) {
            selectedMonthKey = prev
        }
    }
    
    private func nextMonth() {
        if let next = MonthKey.next(selectedMonthKey) {
            selectedMonthKey = next
        }
    }
}
