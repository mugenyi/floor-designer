//
//  LandingView.swift
//  WhiteBackground
//
//  Created by henry on 28/11/2024.
//

import SwiftUI

struct LandingView: View {
    @Binding var selection:OnboardingSelection
    @State var tabCount = 1
    @State var canContinue:Bool =  false
    @EnvironmentObject var editor:EditorViewModel
    
    var body: some View {
            
        VStack{
            
            TabView(selection: $tabCount) {
                
                Page1(tabCount: $tabCount,selection: $selection)
                    .tag(1)
                
            }
           
            
        }.ignoresSafeArea()

            
          


    }
}

#Preview {
    
    LandingView(selection:.constant(.landing))
}
