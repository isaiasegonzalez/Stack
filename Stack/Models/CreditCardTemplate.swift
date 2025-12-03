//
//  CreditCardTemplate.swift
//  Stack
//
//  Created by Isaias Gonzalez on 12/1/25.
//

import Foundation

struct CreditCardTemplate: Identifiable {
    let id = UUID()
    let name: String
    let benefits: String
    let lightLogoImage: String
    let darkLogoImage: String
    let topGradientColor: String
    let bottomGradientColor: String
}

let cardTemplates: [CreditCardTemplate] = [
    CreditCardTemplate(
        name: "Sapphire Reserve",
        benefits: """
                            Cardholders earn 3X points on travel and dining (after earning your annual travel credit) and 1X on all other purchases. It provides an annual $300 travel credit, Priority Pass™ airport lounge access, comprehensive travel insurance, and perks like Global Entry/TSA PreCheck reimbursement. Points are worth 50% more when redeemed for travel through Chase Ultimate Rewards®, and users can also transfer points 1:1 to top airline and hotel partners. These benefits make it ideal for those seeking luxury travel experiences and strong rewards value.
                            """,
        lightLogoImage: "ChaseWhite",
        darkLogoImage: "ChaseBlack",
        topGradientColor: "ChaseTop",
        bottomGradientColor: "ChaseBottom"
    ),
    CreditCardTemplate(
        name: "Gold Card",
        benefits: """
                            Cardholders earn 4X Membership Rewards® points at restaurants (including takeout and delivery) and at U.S. supermarkets (on up to $25,000 per year, then 1X), 3X points on flights booked directly with airlines or on amextravel.com, and 1X on other purchases. The card offers up to $120 in annual dining credits (enrollment required) and up to $120 in Uber Cash for rides or eats in the U.S. (when added to your Uber account). With no foreign transaction fees and premium purchase protection, it’s perfect for food lovers and frequent travelers seeking rich, everyday rewards and valuable lifestyle perks.
                            """,
        lightLogoImage: "AmericanExpressWhite",
        darkLogoImage: "AmericanExpressBlack",
        topGradientColor: "AmericanExpressTop",
        bottomGradientColor: "AmericanExpressBottom"
    ),
    CreditCardTemplate(
        name: "Venture X",
        benefits: """
                        Cardholders earn an unlimited 2X miles on all purchases and 10X miles on hotels and rental cars plus 5X on flights booked through Capital One Travel. The card includes an annual $300 travel credit, 10,000 anniversary bonus miles each year, and complimentary access to Priority Pass™ and Capital One Lounges. With trusted travel protections, Global Entry or TSA PreCheck® credit, and flexible 1:1 transfer options to airline and hotel partners, the Venture X offers exceptional value for frequent travelers looking for luxury benefits with a straightforward earning structure.
                        """,
        lightLogoImage: "CapitalOneWhite",
        darkLogoImage: "CapitalOneBlack",
        topGradientColor: "CapitalOneTop",
        bottomGradientColor: "CapitalOneBottom"
    )
]
