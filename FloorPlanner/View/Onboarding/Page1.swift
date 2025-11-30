//
//  Page1.swift
//  AnimeMaker
//
//  Created by henry on 14/01/2025.
//

import SwiftUI

struct Page1: View {
    @Binding var tabCount: Int
    @Binding var selection:OnboardingSelection
    let myWidth = UIScreen.main.bounds.width
    @State var visibleList = false
    
    var body: some View {
        ZStack{
            
            HStack{
                Spacer()
            }
            
            VStack{
             
              
                VStack {
                    
                    Spacer()
                    ImagePairView()
                    Spacer()
                    
                    Text("Redesign your floor with AI in seconds.").font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom,2)  .multilineTextAlignment(.center)
                    
                    
                    AnimatedListView()
                        .padding(.horizontal)
                    
                    Spacer()
              
               

////
                    Button {
                        
                        selection = .payment
                     
                        
                    } label: {
                        Text("Get Started")
                            .frame(width: 300)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.accentColor)
                            .clipShape(.rect(cornerRadius: 20))
                    }.padding(.bottom,100)
                    
                    
                }
          
                
         
                
                
          
                  
                
                
            }
                .ignoresSafeArea(.container, edges: .bottom)
             
        }.ignoresSafeArea()
        .background{
            Background()
                .frame(width: myWidth)
        }
    }
}

#Preview {
    Page1(tabCount: .constant(1),selection: .constant(.payment))
        
        
}
