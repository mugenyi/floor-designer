//
//  MainActionButton.swift
//
//  Created by henry on 25/04/2025.
//

import SwiftUI

struct MainActionButton: View {

    var image:String
    var color:ColorResource
    var title:String
    @EnvironmentObject var layoutVM:LayoutManager
    
    var body: some View {
        
        VStack{
            Image(systemName:image)
                .font(.title)
                .frame(width:layoutVM.isIpad ? 80 : 40)
            
            Text(title)
                .font(layoutVM.isIpad ? .headline : .footnote)
                .padding(.top,2)
                .foregroundStyle(.white)
                
                
        
        }.frame(width: layoutVM.isIpad ? 180 :  115,height: layoutVM.isIpad ? 150: 90)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
    }
}

#Preview {
    MainActionButton(image: "hand.point.up.left.and.text", color: .accent,title:"Choose Text")
        .environmentObject(LayoutManager())
}
