//
//  ProBannerView.swift
//  AiTextToSpeech
//
//  Created by henry on 19/05/2025.
//

import SwiftUI

struct ProBannerView: View {
    var onUpgradeTap: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Image("crown")
                .resizable()
                .scaledToFit()
                .frame(width:40)
                .foregroundColor(.yellow)

            VStack(alignment: .leading, spacing: 4) {
                Text("Upgrade to Pro")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Unlock all premium features.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }

            Spacer()

            Button(action: onUpgradeTap) {
                Text("Try now")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
        .frame(maxWidth: 500)
    }

}
