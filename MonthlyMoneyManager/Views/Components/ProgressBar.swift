//
//  ProgressBar.swift
//  MonthlyMoneyManager
//
//  Created on 2025-12-28.
//

import SwiftUI

struct ProgressBar: View {
    var value: Double // 0.0 to 1.0
    var color: Color
    var height: CGFloat = 10
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: height)
                    .cornerRadius(height / 2)
                
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * CGFloat(min(value, 1.0)), height: height)
                    .cornerRadius(height / 2)
            }
        }
        .frame(height: height)
    }
}
