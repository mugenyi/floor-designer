//
//  OnboardingView.swift
//  WhiteBackground
//
//  Created by henry on 28/11/2024.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selection:OnboardingSelection = .landing
    
    
    var body: some View {
        TabView(selection: $selection) {
            switch selection {
            case .landing:
                LandingView(selection: $selection)
            case .payment:
                PaymentView(selection: $selection)
            }
      
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(.page(backgroundDisplayMode: .never))
    
            
    }
    

}

#Preview {
    OnboardingView()
}
