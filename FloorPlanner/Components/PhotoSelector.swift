//
//  PhotoSelector.swift
//  RemoveText
//
//  Created by henry on 03/03/2025.
//

import SwiftUI
import PhotosUI

struct PhotoSelector: View {
    @Binding var isLoading:Bool
    @Binding var selectedImage:UIImage?

    @EnvironmentObject var subscription:Subscription
    @EnvironmentObject var creditVM:CreditsViewModal
    @State private var pickersItem:PhotosPickerItem?
    @State var availableCredits =  0

    
    var body: some View {
        VStack{
            
            if creditVM.currentUsage  ==  0 || subscription.isSubscribed {
                
                
                PhotosPicker(selection: $pickersItem,matching: .images){
                                SelectButton()
                    
                }
                .onChange(of: pickersItem) {
                    
               
                    Task {
                        
                        guard  let  data = try await pickersItem?.loadTransferable(type: Data.self) else {
                            
                            return
                        }
                        
                        guard let image = UIImage(data:data) else{
                            
                            return
                            
                        }
                        pickersItem = nil
                        
                    
                         selectedImage = image.resized(toPercentage: 0.7)
                            
                         isLoading = true
                            
                            
                
                            
                            
                        
                        
                        
                        
                    }
                   
                 
                    
                }
            }else{
                
                Button {
                    
                    subscription.showPaymentSheet.toggle()
                    
                } label: {
                    SelectButton()
                }
                
                
            }
        }
    }
    
}

#Preview {
    PhotoSelector(isLoading: .constant(false), selectedImage: .constant(nil))
}
