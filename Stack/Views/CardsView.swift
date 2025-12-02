//
//  CardsView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI

struct CardsView: View {
    @EnvironmentObject var creditCardViewModel: CreditCardViewModel
    @State private var selectedCardID: Int? = nil
    @State private var showAddCardSheet = false

    // Selected Card
    var selectedCard: CreditCard? {
        creditCardViewModel.creditCards.first(where: { $0.id == selectedCardID })
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {

                    // MARK: - Select a Card
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(creditCardViewModel.creditCards) { card in
                                Button {
                                    selectedCardID = card.id
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
                                        color: selectedCardID == card.id ? Color.black.opacity(0.25) : Color.clear,
                                        radius: 6, x: 0, y: 4
                                    )
                                    .scaleEffect(selectedCardID == card.id ? 1.05 : 1.0)
                                    .animation(.easeInOut(duration: 0.15), value: selectedCardID)
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            creditCardViewModel.creditCards.removeAll { $0.id == card.id }
                                            if selectedCardID == card.id { selectedCardID = nil }
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
                    .padding()

                    // Card Details
                    if let card = selectedCard {
                        VStack(alignment: .leading, spacing: 16) {
                            // Card Header
                            VStack(alignment: .leading, spacing: 6) {
                                Text(card.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading) {
                                        Text("Balance")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text("$\(String(format: "%.2f", card.balance))")
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

                            // Benefits
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Card Benefits")
                                    .font(.headline)
                                Text(card.benefits)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                    } else {
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
                .padding(.bottom, 40)
            }
            .navigationTitle("Cards")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGray6))
            .sheet(isPresented: $showAddCardSheet) {
                AddCardSheet { newCard in
                    creditCardViewModel.creditCards.append(newCard)
                }
            }
        }
    }
}

#Preview {
    CardsView()
        .environmentObject(CreditCardViewModel())
}
