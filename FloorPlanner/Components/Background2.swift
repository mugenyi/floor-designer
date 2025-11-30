//
//  Background2.swift
//  AvatarCreator
//
//  Created by henry on 11/02/2025.
//

import SwiftUI

struct Background2: View {
    var body: some View {
    
        ZStack{
                Image("Page2")
                    .resizable()
                    .scaledToFill()
                LinearGradient(colors: [Color("GradientColor1").opacity(0.85),Color("GradientColor2").opacity(0.85),Color("GradientColor3").opacity(0.85)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
            }.ignoresSafeArea()
            
         
                
      
    }
}

#Preview {
    Background2()
}
