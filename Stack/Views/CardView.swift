//
//  CardView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI

struct CardView: View {
    let name: String
    let lightLogoImage: String
    let topGradientColor: String
    let bottomGradientColor: String
    let lastFourDigits: String
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(topGradientColor), Color(bottomGradientColor)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                VStack(alignment: .leading, spacing: 60) {
                    // Bank Logo
                    HStack {
                        Image(lightLogoImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .padding(.leading, 10)
                    }
                    // Card Info
                    HStack {
                        Text(name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Spacer()
                        Text(lastFourDigits)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 10)
                }
        }
        .frame( height: 120)
    }
}

#Preview {
    VStack(spacing: 20) {
        CardView(
            name: "Sapphire Reserve",
            lightLogoImage: "ChaseWhite",
            topGradientColor: "ChaseTop",
            bottomGradientColor: "ChaseBottom",
            lastFourDigits: "1234"
        )
    }
}
