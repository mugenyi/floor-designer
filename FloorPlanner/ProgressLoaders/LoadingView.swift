//
//  Loading.swift
//  WhiteBackground
//
//  Created by henry on 27/11/2024.
//

import SwiftUI

struct LoadingView: View {
    var message:String = "Please wait ... This may take a few seconds, hang in there!"
    var body: some View {
        ZStack{
            Color(.black).ignoresSafeArea()
          
            VStack{
                ProgressView().scaleEffect(2.3)
                    .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                
               
                
                Text( message ).font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(.top)
                
                ProgressLoaderView()
                
                
            }.frame(width: 250)
          
            
        }

    }
}

#Preview {
    LoadingView()
}
