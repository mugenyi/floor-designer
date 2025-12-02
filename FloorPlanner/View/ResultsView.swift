//
//  ResultsView.swift
//  AnimeMaker
//
//  Created by henry on 09/01/2025.
//

import SwiftUI

struct ResultsView:View {
    
    @EnvironmentObject var editor:EditorViewModel
    @EnvironmentObject var subscription:Subscription
    @EnvironmentObject var layout:LayoutManager
    @EnvironmentObject var creditVM:CreditsViewModal
    @Environment(\.dismiss)  var dismiss
    @State var selectedTab:Int  = 0
    @State var activeImage:String = ""
    @State var showShareSaveOptions =  true
    @State var showOriginal = false
    @State var title = "Upscaled 2x"
    @State var activeBtn =  "1x"
    @State var selectedColor =  Color.green
    @State var  blurEffect:Float = 25.0;
    @State var showTextEditor =  false
    @State var canSubmit =  false
    @FocusState  var isTextFieldFocused: Bool
    @State var showRating =  false
    @State var showWatermark =  true
    @State var imageHasLoaded = false
    @AppStorage("hasRated") var hasRated:Bool?
    
    
  
     
    var body: some View {
        
        ZStack {
            Background()
            
            VStack(spacing: 15){
    
                Spacer()
                CarouselView()
                
                if !subscription.isSubscribed && imageHasLoaded {
                    
                    Toggle("Show Watermark", isOn: $showWatermark)
                        .tint(.accent).padding(.horizontal)
                    
                    
                }
                
                Spacer()
                
                FooterView()
           
                
            }
            
            .alert(editor.errorMessage, isPresented: $editor.canShowErrorAlert) {
                Button("OK", role: .cancel) {}
            }
            
            .alert(editor.alertMessage, isPresented: $editor.canShowMessageAlert) {
                Button("OK", role: .cancel) {}
            }
            .onAppear{
                
                activeImage = editor.result.image
                creditVM.increaseCredit()
          
            }
            .onChange(of: editor.edittedImage) { oldValue, newValue in
                
                activeImage = ""
                activeImage =  newValue
            }
            
            
            if (editor.isLoading){
                LoadingView()
            }
            
            AlertModal(showAlert: $showRating)
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing){
                
                Button{
                    
                    showOriginal.toggle()
                    
                } label: {
                    VStack{
                        Image(systemName: showOriginal ? "photo.artframe" : "photo")
                    
                        if showOriginal{
                            Text("New Design")
                                .font(.footnote)
                        }else {
                            Text("Original Design")
                                .font(.footnote)
                        }
                     
                    }
                    
                }
                
       
            }
            
   

            
        }
        
        .onDisappear{
            editor.selectedImage = nil
            editor.selectedRoomType = nil
            editor.selectedRoomStyle =  nil
            
        }
        .onChange(of: showWatermark, { oldValue, newValue in
            
            if showWatermark == false && !subscription.isSubscribed {
                
                subscription.showPaymentSheet =  true
                
                showWatermark =  true
            }
        })

        
            .fullScreenCover(isPresented: $subscription.showPaymentSheet){
                MyPurchaseView(isPresented: $subscription.showPaymentSheet)
           
     
            }.sheet(isPresented: $showTextEditor) {
                
                
                VStack {
                    HStack {
                        
                        Spacer()
                        
                        Button{
                            
                            showTextEditor =  false
                            
                        }label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(Color.accentColor)
                                .font(.title2)
                        }.buttonStyle(.plain)
                        
                        
                    }
                    Spacer()
                    
                    MyTextEditor(editor: editor, isTextFieldFocused: $isTextFieldFocused, canSubmit: $canSubmit)
                    
                    Button {
                        
                        if !subscription.isSubscribed {
                            
                            subscription.showPaymentSheet =  true
                            
                            return
                        }
                        

                        showTextEditor =  false
                        
                
                        Task {
                            activeImage = ""
                            
                            do {
                                
                                editor.canRedirect = false
                                try await editor.editImage()
                            
                                
                            }catch {
                                
                                editor.isLoading = false
                                
                            }
    
                        }

                                      
                        
                    } label: {
                        HStack{
                            
                            Image(systemName: "wand.and.sparkles.inverse")
                                .padding(.vertical,5)
                                .padding(.trailing,2)
                            Text("Submit")
                            
                        }.foregroundStyle(.white)
                            .padding(.horizontal)
                        
                        
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                    .disabled(!canSubmit)
                    
                    Spacer()
                    
                }.presentationDetents([.medium])
                    .padding()
              
                
            }
        
         
    }
    
    

    
    
    @ViewBuilder
    func FooterView () -> some View {
        
            
            HStack{
                
                
                Spacer()
                
                Button {
                    Task{
                        
                        Task{
                            await editor.saveImageToGallery(url: activeImage,hasWatermark: !subscription.isSubscribed){
                                           if hasRated != nil {
                                               self.editor.isLoading =  false
                                               self.editor.alertMessage = String(localized: "Image has been saved")
                                               self.editor.canShowMessageAlert = true
                                               
                                           }else {
                                               self.editor.isLoading =  false
                                               showRating =  true
                                               
                                           }
                                       }
                        }
                        
                    }
                    
                    
                } label: {
                    HStack{
                        
                        Image(systemName: "square.and.arrow.down")
                            .padding(.vertical,5)
                            .padding(.trailing,2)
                        Text("Save")
                        
                    }.foregroundStyle(.white)
                        .padding(.horizontal)
                    
                    
                    
                }
                .buttonStyle(.borderedProminent)
            
                
                
                
                
                Spacer()
                
                
                Button {
                    
                    guard let url = URL(string: activeImage) else{
                        return
                    }
                    
                    editor.shareImage(from: url)
                    
                    
                } label: {
                    HStack{
                        Image(systemName: "square.and.arrow.up")
                            .padding(.vertical,5)
                            .padding(.trailing,2)
                        
                        Text("Share")
                        
                    }  
                        .padding(.horizontal)
                    
                    
                }.buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
            
                  
                
                
                Spacer()
            }
            .padding()
           

        
        
        HStack{
            
            Spacer()
            
            
            
            Button {
                
                Task {
                    
                    do {
                        
                        try await editor.upscaleImage()
                        
                    } catch {
                        
                        editor.isLoading =  false
                    }
                    
                }
                
                
            } label: {
                
                MainActionButton(image: "square.resize", color: .gradientColor2, title: String(localized:"Upscale Image"))
          
            }
            
            
            
            
            Button {
                
                if !subscription.isSubscribed {
                    
                    subscription.showPaymentSheet =  true
                    
                    return
                }
             
                Task {
                    
                    do {
                        
                        try await editor.uploadImage()
                        
                    } catch {
                        
                        editor.isLoading =  false
                    }
                    
                }
                
                
            } label: {
                
                MainActionButton(image: "arrow.trianglehead.2.counterclockwise", color: .gradientColor2, title: String(localized: "Try Again"))
                    .overlay {
                        if  !subscription.isSubscribed {
                            
                            VStack {
                                HStack{
                                    Spacer()
                                    Image(systemName: "lock.fill")
                                    
                                        .foregroundStyle(.white)
                                        .padding(8)
                                        .background {
                                            Color.accentColor.opacity(0.5)
                                                .clipShape(RoundedRectangle(cornerRadius: 400))
                                        }
                                }.padding(5)
                                
                                Spacer()
                            }
                            
                        }
                    }
            }
            
            
            
            
            
            Button {
                
                showTextEditor =  true
                
                
            } label: {
                
                MainActionButton(image: "sparkles", color: .gradientColor2, title: String(localized:"Edit Image"))
                    .overlay {
                        if  !subscription.isSubscribed {
                            
                            VStack {
                                HStack{
                                    Spacer()
                                    Image(systemName: "lock.fill")
                                    
                                        .foregroundStyle(.white)
                                        .padding(8)
                                        .background {
                                            Color.accentColor.opacity(0.5)
                                                .clipShape(RoundedRectangle(cornerRadius: 400))
                                        }
                                }.padding(5)
                                
                                Spacer()
                            }
                            
                        }
                    }
            }
            
            
            Spacer()
            
        }
 
   
      
        Spacer()
    }
    
    
    
    
    @ViewBuilder
    func CarouselView() -> some View{
         
           

            VStack{
                
                if !showOriginal {
                    AsyncImage(url: URL(string: activeImage)) { LoadedImage in
                        
                        LoadedImage.resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                            .overlay{
                                if !subscription.isSubscribed {
                                    VStack{
                                        HStack {
                                            
                                            Button {
                                                
                                                subscription.showPaymentSheet =  true
                                                
                                            } label: {
                                                
                                                
                                                Text(Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "")
                                                    .font(.footnote)
                                                    .foregroundStyle(.white)
                                                    .shadow(color: .black, radius: 4, x: 0, y: 0)
                                                    .padding(.top)
                                                    .padding(.leading)
                                            }
                                            Spacer()
                                        }
                                        
                                        Spacer()
                                        
                                        
                                        Button {
                                            
                                            subscription.showPaymentSheet =  true
                                            
                                        } label: {
                                            
                                            
                                            Text("whitebg.net")
                                                .font(.footnote)
                                                .foregroundStyle(.white)
                                                .shadow(color: .black, radius: 4, x: 0, y: 0)
                                                .padding(.bottom,30)
                                        }
                                        
                                    }
                                }
                            }
                            .onAppear{
                                imageHasLoaded =  true
                            }
                        
                        
                    }
                    
                    placeholder: {
                        ProgressView()
                        
                    }
                } else {
                    
                    if let image = editor.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                        
                    }
                    
                  
                }
                
            }

      
            
    
        
    }
    


    
    
    
}

#Preview {
    
    
    
    ResultsView()
        .environmentObject(EditorViewModel())
        .environmentObject(LayoutManager())
        .environmentObject(Subscription())
        .preferredColorScheme(.dark)
}
