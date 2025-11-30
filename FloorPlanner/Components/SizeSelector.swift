//
//  SizeSelector.swift
//  AnimeMaker
//
//  Created by henry on 09/01/2025.
//

import SwiftUI

struct SizeSelector: View {
    @Binding var selectedSize:ImageSizes
    let myWidth = UIScreen.main.bounds.width

    var body: some View {
        
        VStack(alignment: .leading){
            Text("Select Size")
                .font(.headline)
        
            HStack{
                
                Button {
                    selectedSize = .square
                    
                } label: {
                    VStack{
                        Image(systemName: "square")
                            .font( myWidth > 600 ? .largeTitle : .title)
                        
                   
                            .padding(.top,3)
                    }.frame(width: myWidth > 600 ? 100 : 80, height: myWidth > 600 ? 100 : 80)
                        .foregroundStyle(.white)
                        .background(Color("MyLightGray").opacity(0.4))
                        .overlay{
                            if selectedSize ==  .square  {
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .font(myWidth > 600 ? .title : .headline)
                                    .padding(2)
                                    .background(.white)
                                    .clipShape(.circle)
                                  

                                     .position(x:65, y:20)
                                    
                                
                            }
                            
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                }
                
                Button {
                    selectedSize = .rectangle
                    
                } label: {
                    VStack{
                        Image(systemName: "rectangle")
                            .font( myWidth > 600 ? .largeTitle : .title)
                       
                            .padding(.top,3)
                    }.frame(width: myWidth > 600 ? 100 : 80, height: myWidth > 600 ? 100 : 80)
                        .foregroundStyle(.white)
                        .background(Color("MyLightGray").opacity(0.4))
                        .overlay{
                            if selectedSize ==  .rectangle  {
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .font(myWidth > 600 ? .title : .headline)
                                    .padding(2)
                                    .background(.white)
                                    .clipShape(.circle)
                                  

                                     .position(x:65, y:20)
                                    
                                
                            }
                            
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                Button {
                    selectedSize = .tower
                    
                } label: {
                    
                    VStack{
                        Image(systemName: "rectangle.portrait")
                            .font( myWidth > 600 ? .largeTitle : .title)
                     
                            .padding(.top,3)
                    }.frame(width: myWidth > 600 ? 100 : 80, height: myWidth > 600 ? 100 : 80)
                        .foregroundStyle(.white)
                        .background(Color("MyLightGray").opacity(0.5))
                        .overlay{
                            if selectedSize ==  .tower  {
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .font(myWidth > 600 ? .title : .headline)
                                    .padding(2)
                                    .background(.white)
                                    .clipShape(.circle)
                                  

                                     .position(x:65, y:20)
                                    
                                
                            }
                            
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                   
                }


                

 
            }
            
    
            
        }
    
    }
}

#Preview {
    SizeSelector(selectedSize: .constant(.square))
}
