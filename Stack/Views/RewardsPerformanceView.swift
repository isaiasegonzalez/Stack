//
//  RewardsPerformanceView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI
import Charts

struct RewardsPerformanceView: View {
    @State private var selectedRange: String = "1W"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rewards Performance")
                .font(.headline)
                .padding(.horizontal)
            
            // Totals section
            HStack(spacing: 40) {
                HStack(spacing: 6) {
                    Circle().fill(Color.blue).frame(width: 10, height: 10)
                    VStack(alignment: .leading) {
                        Text("Actual Rewards")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("$21.90")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
                
                HStack(spacing: 6) {
                    Circle().fill(Color.pink).frame(width: 10, height: 10)
                    VStack(alignment: .leading) {
                        Text("Potential Rewards")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("$25.16")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.horizontal)
            
            // Placeholder "chart area"
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                
                VStack(spacing: 6) {
                    Image(systemName: "chart.xyaxis.line")
                        .font(.system(size: 32))
                        .foregroundColor(.gray.opacity(0.6))
                    Text("Rewards data unavailable")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 200)
            .padding(.horizontal)
            
            // Time range buttons (visual only)
            HStack(spacing: 16) {
                ForEach(["1W", "1M", "3M", "1Y", "All"], id: \.self) { range in
                    Button {
                        selectedRange = range
                    } label: {
                        Text(range)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 14)
                            .background(
                                selectedRange == range ?
                                Color(.systemGray5) : Color.clear
                            )
                            .clipShape(Capsule())
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}

#Preview {
    RewardsPerformanceView()
}
