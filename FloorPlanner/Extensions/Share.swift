//
//  Share.swift
//  AnimeMaker
//
//  Created by henry on 13/01/2025.
//

import SwiftUI

extension View {
    
    func presentShareLink() {

    
        guard let url = URL(string: "https://apps.apple.com/us/app/anime-character-creator/id6740197197") else { return }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        let scene = UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
        scene?.keyWindow?.rootViewController?.present(vc, animated: true)
    }
}
