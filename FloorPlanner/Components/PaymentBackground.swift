//
//  PaymentBackground.swift
//  AnimeMaker
//
//  Created by henry on 13/01/2025.
//

import SwiftUI


struct PaymentBackground:View {
    var body: some View {
        ZStack{
//            VStack{
//                Image("PaymentBackground")
//                    .resizable()
//                    .scaledToFill()
//            }.ignoresSafeArea()
            
            LinearGradient(colors: [.black.opacity(0),Color("GradientColor1").opacity(0.9),Color("GradientColor1")], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        }
    }
}


#Preview {
    PaymentBackground()
}
