//
//
//  Created by henry on 29/11/2024.
//

import SwiftUI

struct SelectImageIconView: View {
    var icon:String
    var step:String
    var title: String
    
    @EnvironmentObject var editorVM:EditorViewModel
    @EnvironmentObject var layoutVM:LayoutManager
    
  
    var body: some View {

        
        VStack{
            
            HStack{
                Image(systemName: icon)
                    .padding(10)
                    .foregroundStyle(.white)
                    .background{
                        Color.accentColor
                           
                    }.clipShape(Circle())
                VStack(alignment:.leading){
                    Text(step)
                        .foregroundStyle(Color(.accent))
                        
                    Text(title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                
                
                
                Spacer()
                
                if icon == "photo" &&  editorVM.selectedImage != nil   {
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.accent)
                        .font(.title)
                    
                 
                    
                } else if icon == "house" &&  editorVM.selectedRoomType != nil   {
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.accent)
                        .font(.title)
                }
                
                if icon == "paintbrush" &&  editorVM.selectedRoomStyle != nil   {
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.accent)
                        .font(.title)
                    
                    
                }
                
             
                
                
 
                
                
                
            }.padding()
            
            
  
            
       
            if icon == "photo" && editorVM.selectedImage == nil {
                Spacer()
                
                HStack{
                    Spacer()
                    Image(systemName: "photo.badge.plus.fill")
                        .foregroundStyle(.accent)
                        .font(.largeTitle)
                        
                    Spacer()
                }
                .frame(height:250)
                .padding()
             
                
                Spacer()
                
            }
            
            if let image =  editorVM.selectedImage  {
                
                if icon == "photo" {
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150,height: 150)
                    
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom)
                        .overlay {
                            VStack{
                                
                                Image(systemName: "trash")
                                    .font(.system(size: 18, weight: .medium))
                                
                                    .frame(width: 32, height: 32)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                
                                
                            }
                        }
                }
            }
            
            
            if let roomType =  editorVM.selectedRoomType  {
                
                if icon == "house" {
                    
                    MainActionButton(image: roomType.icon, color: .gradientColor2, title: roomType.localizedName)
                    
             
                }
            }
            
             
            if let roomStyle =  editorVM.selectedRoomStyle {
                
                if icon == "paintbrush" {
                    
                    VStack{
                        
                     
                        if editorVM.selectedRoomStyle != .image {
                            
                            
                            
                            Image(roomStyle.rawValue)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150,height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay {
                                    VStack{
                                        
                                        Image(systemName: "trash")
                                            .font(.system(size: 18, weight: .medium))
                                        
                                            .frame(width: 32, height: 32)
                                            .background(.ultraThinMaterial)
                                            .clipShape(Circle())
                                        
                                        
                                    }
                                }
                            
                        } else {
                            
                            if let image =  editorVM.selectedStyleImage  {
                                
                                Image(uiImage: image )
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150,height: 150)
                                
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(.bottom)
                                    .overlay {
                                        VStack{
                                            
                                            Image(systemName: "trash")
                                                .font(.system(size: 18, weight: .medium))
                                            
                                                .frame(width: 32, height: 32)
                                                .background(.ultraThinMaterial)
                                                .clipShape(Circle())
                                            
                                            
                                        }
                                    }
                            }
                        }
                            
                            Text(roomStyle.localizedName)
                                .font(.footnote)
                                .foregroundStyle(.white)
                        
                        
                        if let prompt =  editorVM.customStylePrompt   {
     
                                Text(prompt)
                                    .font(.footnote)

                            
                        }
                            
                      
                    }.padding(.bottom)
                 
                }
            }
    
            
            
            
            
            
            
          
            
        }.background{
                Color(.secondarySystemBackground)
                    .cornerRadius(20)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(style: StrokeStyle(lineWidth: 2))
            }
            .padding(.bottom)
        
        
    }
}

#Preview {
    SelectImageIconView(icon:"photo",step: "Step1", title: "Select Photo")
        .environmentObject(LayoutManager())
        .environmentObject(EditorViewModel())
        .preferredColorScheme(.dark)
}
