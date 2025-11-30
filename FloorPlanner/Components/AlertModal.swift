//
//  AlertModal.swift
//  RemoveText
//
//  Created by henry on 20/01/2025.
//

import SwiftUI
import StoreKit

struct AlertModal: View {
    @Binding var showAlert:Bool
    @AppStorage("hasRated") var hasRated:Bool?
    
    var body: some View {
       
            if showAlert {
                
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                        GroupBox{
                            
                            HStack{
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        showAlert = false
                                    }
                                    
                                } label: {
                                    
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                }
                                
                            }
                            VStack(spacing: 15) {
                                Text("🐣")
                                    .font(.largeTitle)
                                
                                Text("Image saved successfully!")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Text("If you love our app please add a 5-Star rating and a review")
                                    .font(.subheadline)
                                
                                Button {
                                    withAnimation {
                                        showAlert = false
                                    }
                                    
                            
                                        
                                    openAppStoreReviewPage()
                                    
                                    
                                    hasRated = true
                                    
                                } label: {
                                    Text("Rate Us")
                                        .foregroundStyle(.white)
                                        .padding(.horizontal)
                                }.buttonStyle(.borderedProminent)
                                
                                
                                
                            }.multilineTextAlignment(.center )
                               
                        }
                        .transition(.asymmetric(insertion:.scale, removal: .scale(scale: 0).combined(with: .opacity)))
                        .frame(maxWidth: 350)
                        .background{
                            Background()
                        }
                     
                        
                        Spacer()
                        
                    }
                    
                    Spacer()
                    
                }.preferredColorScheme(.dark)
                    .background(Color(.black).opacity(0.6))
                
                
            }
        
    
    }
    
    
    func openAppStoreReviewPage() {
        let appStoreID = "6744259092"
        if let url = URL(string: "https://apps.apple.com/app/id\(appStoreID)?action=write-review"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

#Preview {
    AlertModal(showAlert: .constant(true))
}
