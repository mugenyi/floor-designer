//
//  PaymentView.swift
//  WhiteBackground
//
//  Created by henry on 28/11/2024.
//

import SwiftUI
import StoreKit

struct PaymentView: View {
    @Binding var selection:OnboardingSelection
    @EnvironmentObject var onboarding: Onboarding
    @EnvironmentObject var subscription:Subscription
    @AppStorage("onboarding") var onboardingStatus:Bool?
    @State var isShowing = true
    @Environment(\.dismiss) var dismissSheet
 
    
    
    
    var body: some View {
   
        VStack{
              
            
            MyPurchaseView(isPresented:$isShowing)
            
                

        }.onChange(of: isShowing) { oldValue, newValue in
                
                onboarding.completedOnboarding = true
                onboardingStatus = true
                dismissSheet()
            
        }
            
            
            
            
        }
    }


#Preview {
    @Previewable @State var selection : OnboardingSelection = .landing
    PaymentView(selection: $selection)
        .environmentObject(Subscription())
}
