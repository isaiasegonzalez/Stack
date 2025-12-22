//
//  RewardsPerformanceView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI
import Charts
import SwiftData

struct RewardsPerformanceView: View {
    @Query(sort: \Transaction.date, order: .reverse) var transactions: [Transaction]
    
    @State private var selectedRange: String = "1W"
    
    // Filtered transactions
    var filtered: [Transaction] {
        let now = Date()
        switch selectedRange {
        case "1W":
            return transactions.filter { $0.date >= now.addingTimeInterval(-7 * 24 * 60 * 60) }
        case "1M":
            return transactions.filter { $0.date >= now.addingTimeInterval(-30 * 24 * 60 * 60) }
        case "3M":
            return transactions.filter { $0.date >= now.addingTimeInterval(-90 * 24 * 60 * 60) }
        case "1Y":
            return transactions.filter { $0.date >= now.addingTimeInterval(-365 * 24 * 60 * 60) }
        default:
            return transactions
        }
    }
    
    var actualRewards: Double {
        filtered.reduce(0) { $0 + $1.cashback }
    }
    
    var potentialRewards: Double {
        filtered.reduce(0) { $0 + ($1.potentialCashback ?? $1.cashback) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rewards Performance")
                .font(.headline)
                .padding(.horizontal)
            
            // totals
            HStack(spacing: 40) {
                HStack(spacing: 6) {
                    Circle().fill(Color.blue).frame(width: 10, height: 10)
                    VStack(alignment: .leading) {
                        Text("Actual Rewards")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("$\(actualRewards, specifier: "%.2f")")
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
                        Text("$\(potentialRewards, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.horizontal)
            
            // Chart OR Placeholder
            if filtered.isEmpty {
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
            } else {
                Chart {
                    ForEach(filtered) { txn in
                        LineMark(
                            x: .value("Date", txn.date),
                            y: .value("Actual", txn.cashback),
                            series: .value("Type", "Actual")
                        )
                        .interpolationMethod(.catmullRom)         // smooth curve
                        .foregroundStyle(Color.blue.gradient)     // pretty gradient
                        .symbol(Circle())                         // circle dots
                        .symbolSize(30)                           // dot size
                        if let potential = txn.potentialCashback, potential > txn.cashback {
                            LineMark(
                                x: .value("Date", txn.date),
                                y: .value("Potential", potential),
                                series: .value("Type", "Potential")
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(Color.pink.gradient)
                            .symbol(Circle())
                            .symbolSize(30)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.6), value: filtered)   // nice chart animation when range changes
                .frame(height: 200)
                .padding(.horizontal)
            }
            
            // Range selectors
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
