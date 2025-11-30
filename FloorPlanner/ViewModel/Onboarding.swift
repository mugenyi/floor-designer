//
//  Onboarding.swift
//  WhiteBackground
//
//  Created by henry on 29/11/2024.
//


import SwiftUI

class Onboarding: ObservableObject {
    @Published var selection: OnboardingSelection = .landing
    @Published var completedOnboarding:Bool =  false
    
    
}
