//
//  AvatarCard.swift
//  AvatarCreator
//
//  Created by henry on 06/02/2025.
//

import SwiftUI

struct AvatarCard: View {
    var image:String
    var largeSize:Bool = false
    @EnvironmentObject var subscription:Subscription
    @EnvironmentObject var layoutVM:LayoutManager
    
    var body: some View {
    
          
            ZStack{
                
                Image(image)
                   
                    .resizable()
                    .scaledToFill()
                
                    .frame(width: !layoutVM.isIpad ?  100 : 150 , height: !layoutVM.isIpad ? 100 : 150)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
            }
                
        
           
    }
}

#Preview {
    AvatarCard(image: "Original")
        .environmentObject(Subscription())
}
