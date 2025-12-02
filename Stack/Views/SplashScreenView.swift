//
//  SplashScreenView.swift
//  Stack
//
//  Created by Isaias Gonzalez on 10/29/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var opacity = 0.0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Image("Stack")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        opacity = 1.0
                    }
                }
        }
    }
}

#Preview {
    SplashScreenView()
}
