//
//  CardsView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI
import SwiftData

struct CardsView: View {
    // Load cards from SwiftData
    @Query(sort: \CreditCard.name) var cards: [CreditCard]
    
    @EnvironmentObject var creditCardViewModel: CreditCardViewModel
    @Environment(\.modelContext) private var context
    
    @State private var selectedCard: CreditCard? = nil
    @State private var showAddCardSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Card Carousel
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(cards) { card in
                                Button {
                                    selectedCard = card
                                } label: {
                                    CardView(
                                        name: card.name,
                                        lightLogoImage: card.lightLogoImage,
                                        topGradientColor: card.topGradientColor,
                                        bottomGradientColor: card.bottomGradientColor,
                                        lastFourDigits: card.lastFourDigits
                                    )
                                    .frame(width: 180)
                                    .shadow(
                                        color: selectedCard?.id == card.id ? Color.black.opacity(0.25) : .clear,
                                        radius: 6, x: 0, y: 4
                                    )
                                    .scaleEffect(selectedCard?.id == card.id ? 1.05 : 1.0)
                                    .animation(.easeInOut(duration: 0.15), value: selectedCard?.id)
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            context.delete(card)
                                            if selectedCard?.id == card.id {
                                                selectedCard = nil
                                            }
                                        }
                                    } label: {
                                        Label("Delete Card", systemImage: "trash")
                                    }
                                }
                            }
                            // Add Card Button
                            Button {
                                showAddCardSheet.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 36))
                                        .foregroundColor(.blue)
                                    Text("Add Card")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                                .frame(width: 150, height: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue.opacity(0.4), lineWidth: 1)
                                )
                            }
                        }
                        .padding()
                    }
                    // Card Details
                    if let card = selectedCard {
                        cardDetails(card)
                    } else {
                        emptyState
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("Cards")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGray6))
            .sheet(isPresented: $showAddCardSheet) {
                AddCardSheet()
            }
        }
    }
    // Views
    private func cardDetails(_ card: CreditCard) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(card.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                HStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("Balance")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("$\(card.balance, specifier: "%.2f")")
                            .font(.headline)
                    }
                    VStack(alignment: .leading) {
                        Text("Due Date")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(card.dueDate.formatted(.dateTime.month(.abbreviated).day()))
                            .font(.headline)
                    }
                }
            }
            Divider()
            VStack(alignment: .leading, spacing: 8) {
                Text("Card Benefits")
                    .font(.headline)
                Text(card.benefits)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            // Point conversion
            if card.usesPoints, let rate = card.pointToCashRate {
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Point Conversion")
                        .font(.headline)
                    
                    Text("In Stack, each point is treated as **\(String(format: "%.2f", rate * 100))¢** in cashback value.")
                    .font(.body)
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("Select a card to view details")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Image(systemName: "creditcard.fill")
                .font(.largeTitle)
                .foregroundColor(.gray.opacity(0.3))
        }
        .padding(.top, 60)
    }
}

#Preview {
    CardsView()
        .modelContainer(for: [CreditCard.self, Transaction.self], inMemory: true)
        .environmentObject(CreditCardViewModel())
}
