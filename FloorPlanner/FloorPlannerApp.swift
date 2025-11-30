//
//  FloorPlannerApp.swift
//  FloorPlanner
//
//  Created by henry on 10/07/2025.
//

import SwiftUI

@main
struct FloorPlannerApp: App {
    @AppStorage("onboarding") var onboardingStatus: Bool?
    @ObservedObject var onboarding =  Onboarding()
    @ObservedObject var subsbscription = Subscription()
    @ObservedObject var creditVm = CreditsViewModal()
    @ObservedObject var editorVm = EditorViewModel()

    
    
    var body: some Scene {
        
        WindowGroup {
           let  checkOnboardingStatus = onboardingStatus ?? false
            if checkOnboardingStatus || onboarding.completedOnboarding {
                ContentView()
                    .tint(.accentColor)
                    .environmentObject(onboarding)
                    .environmentObject(subsbscription)
                    .environmentObject(editorVm)
                    .environmentObject(LayoutManager())
                    .environmentObject(creditVm)
                    .preferredColorScheme(.dark)
                    .onAppear { UIView.appearance().tintColor = UIColor(named: "AccentColor") }
                
                
            } else {
                OnboardingView()
                    .tint(.accentColor)
                    .environmentObject(onboarding)
                    .environmentObject(subsbscription)
                    .preferredColorScheme(.dark)
                
            }
          
        }
    }
}
