//
//  AddCardSheet.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI

struct AddCardSheet: View {
    @EnvironmentObject var creditCardViewModel: CreditCardViewModel
    var onAdd: (CreditCard) -> Void
    @Environment(\.dismiss) private var dismiss

    // Static Card Options
    private let availableCards: [CreditCard] = [
        CreditCard(
            id: 1,
            name: "Sapphire Reserve",
            balance: 847.32,
            dueDate: ISO8601DateFormatter().date(from: "2025-11-05T00:00:00Z") ?? Date(),
            benefits: """
                Cardholders earn 3X points on travel and dining (after earning your annual travel credit) and 1X on all other purchases. It provides an annual $300 travel credit, Priority Pass™ airport lounge access, comprehensive travel insurance, and perks like Global Entry/TSA PreCheck reimbursement. Points are worth 50% more when redeemed for travel through Chase Ultimate Rewards®, and users can also transfer points 1:1 to top airline and hotel partners. These benefits make it ideal for those seeking luxury travel experiences and strong rewards value.
                """,
            lightLogoImage: "ChaseWhite",
            darkLogoImage: "ChaseBlack",
            topGradientColor: "ChaseTop",
            bottomGradientColor: "ChaseBottom",
            lastFourDigits: "1234"
        ),
        CreditCard(
            id: 2,
            name: "Gold Card",
            balance: 847.32,
            dueDate: ISO8601DateFormatter().date(from: "2025-11-05T00:00:00Z") ?? Date(),
            benefits: """
                Cardholders earn 4X Membership Rewards® points at restaurants (including takeout and delivery) and at U.S. supermarkets (on up to $25,000 per year, then 1X), 3X points on flights booked directly with airlines or on amextravel.com, and 1X on other purchases. The card offers up to $120 in annual dining credits (enrollment required) and up to $120 in Uber Cash for rides or eats in the U.S. (when added to your Uber account). With no foreign transaction fees and premium purchase protection, it’s perfect for food lovers and frequent travelers seeking rich, everyday rewards and valuable lifestyle perks.
                """,
            lightLogoImage: "AmericanExpressWhite",
            darkLogoImage: "AmericanExpressBlack",
            topGradientColor: "AmericanExpressTop",
            bottomGradientColor: "AmericanExpressBottom",
            lastFourDigits: "5678"
        ),
        CreditCard(
            id: 3,
            name: "Venture X",
            balance: 847.32,
            dueDate: ISO8601DateFormatter().date(from: "2025-11-05T00:00:00Z") ?? Date(),
            benefits: """
                Cardholders earn an unlimited 2X miles on all purchases and 10X miles on hotels and rental cars plus 5X on flights booked through Capital One Travel. The card includes an annual $300 travel credit, 10,000 anniversary bonus miles each year, and complimentary access to Priority Pass™ and Capital One Lounges. With trusted travel protections, Global Entry or TSA PreCheck® credit, and flexible 1:1 transfer options to airline and hotel partners, the Venture X offers exceptional value for frequent travelers looking for luxury benefits with a straightforward earning structure.
                """,
            lightLogoImage: "CapitalOneWhite",
            darkLogoImage: "CapitalOneBlack",
            topGradientColor: "CapitalOneTop",
            bottomGradientColor: "CapitalOneBottom",
            lastFourDigits: "9012"
        )
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text("Select Your Institution")
                .font(.headline)
                .padding(.top, 20)

            // Cards List
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                ForEach(availableCards) { card in
                    let alreadyAdded = creditCardViewModel.creditCards.contains { $0.name == card.name }

                    Button {
                        if !alreadyAdded {
                            onAdd(card)
                            dismiss()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(.systemGray6))
                                .frame(height: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(alreadyAdded ? Color.gray.opacity(0.3) : Color.clear, lineWidth: 1)
                                )
                                .opacity(alreadyAdded ? 0.5 : 1.0)

                            Image(card.darkLogoImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120)
                                .opacity(0.95)
                        }
                        .padding(.horizontal)
                    }
                    .disabled(alreadyAdded)
                }
            }

            Button("Cancel", role: .cancel) {
                dismiss()
            }
            .padding(.bottom, 20)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    AddCardSheet { _ in }
        .environmentObject(CreditCardViewModel())
}
