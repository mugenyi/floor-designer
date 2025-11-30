//
//  ContentView.swift
//  AvatarCreator
//
//  Created by henry on 28/01/2025.
//

import SwiftUI
import SimpleKeychain
import PhotosUI
import AVFoundation

struct ContentView: View {
    @State private var pickersItem:PhotosPickerItem?
    @State var path  = NavigationPath()
    @EnvironmentObject var editor:EditorViewModel
    @EnvironmentObject var layoutVM:LayoutManager
    @EnvironmentObject var creditVM:CreditsViewModal
    @State var webPageUrl:URL?
    @State var canShowWebView = false
    let simpleKeychain = SimpleKeychain()
    @State var  showLibrary = false
    @State var showCameraPicker =  false
    @State private var showFilePicker = false
    @State var  showPreview:Bool = false
    @State var showImageCreator =  false
    @State var showActionSelector =  false
    @State var showTypeSelector =  false
    @State var showStyleSelector =  false
    @State var selection:SelectionTypes  = .defaultSyles
    @State var showTextEditor =  false
    @State var canSubmit =  true
    @State private var cameraStatus: AVAuthorizationStatus = .notDetermined
    @State private var permissionGranted: Bool = false
    @State private var showCameraPermissionAlert:Bool = false
    
    @FocusState  var isTextFieldFocused: Bool
    let appName = "Toony"

  
    @EnvironmentObject var subscription:Subscription
    
    let screenWidth = UIScreen.main.bounds.width
    
    
    var samplePrompts = [
        String(localized: "A modern home landscape design with clean geometric lines, a stone pathway leading to the entrance, symmetrical garden beds filled with ornamental grasses and low shrubs, a minimalist water feature in the front yard, soft LED ground lights, and a perfectly trimmed green lawn, all arranged in a sleek, contemporary style."),
        String(localized: "A tropical home garden with tall palm trees, vibrant flowering plants like hibiscus and bougainvillea, a winding stone pathway surrounded by lush greenery, a small koi pond with floating lilies, bamboo fencing, and cozy wooden outdoor seating, creating a resort-like paradise atmosphere."),
        String(localized: "A charming cottage-style home landscape with colorful flower beds filled with roses, lavender, and daisies, a rustic cobblestone pathway leading to a wooden gate, climbing vines on trellises, a white picket fence, and a cozy garden bench shaded by a large oak tree, radiating warmth and homeliness.")
    ]
    
    
    
    func checkCameraPermission() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    
    var body: some View {
        NavigationStack(path: $path){
            ScrollViewReader { proxy in
                
                ScrollView {
                    
                    
                    
                    ZStack{
                        Background()
                        
                        
                        
                        VStack {
                            
                            
                            Spacer()
                            
                            
                            
                            VStack {
                                
                                
                                Button {
                                    
                                    showActionSelector =  true
                                    
                                } label : {
                                    SelectImageIconView(icon: "photo", step: String(localized: "Step 1:"), title:  String(localized: "Select Photo"))
                                }
                                   .onChange(of: editor.selectedImage, { _, _ in
                                    
                                       withAnimation {
                                           proxy.scrollTo(123, anchor: .bottom)
                                                          }
                                    
                                    
                                })
                                
                                
//                                
//                                Button {
//                                    
//                                    showTypeSelector =  true
//                                    
//                                } label : {
//                                    SelectImageIconView(icon: "house", step: String(localized: "Step 2:"), title:  String(localized: "Select Room Type"))
//                                }
//                                .onChange(of: editor.selectedRoomType, { _, _ in
//                                 
//                                    withAnimation {
//                                        proxy.scrollTo(123, anchor: .bottom)
//                                                       }
//                                 
//                                 
//                             })
                                
                                
                                
                                Button {
                                    
                                    showStyleSelector =  true
                                    
                                } label : {
                                    SelectImageIconView(icon: "paintbrush", step: String(localized: "Step 2:"), title:  String(localized: "Select Floor  Style"))
                                }
                                .onChange(of: editor.selectedRoomStyle, { _, _ in
                                 
                                    withAnimation {
                                        proxy.scrollTo(123, anchor: .bottom)
                                                       }
                                 
                                 
                             })
                                
                                
                                
                                
                                
                                Button {
                                    
                              
                                    if creditVM.currentUsage  > 1 && !subscription.isSubscribed {
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
                                    HStack{
                                        if #available(iOS 18.0, *) {
                                            
                                            Image(systemName:  "wand.and.sparkles")
                                                .symbolEffect(.bounce)
                                        } else {
                                            
                                            // Fallback on earlier versions
                                            Image(systemName: "wand.and.sparkles")
                                            
                                        }
                                        Text("Generate Design")
                                        
                                    }.foregroundStyle(.white)
                                        .font(.headline)
                                        .padding()
                                    
                                }.clipShape(.rect(cornerRadius: 20))
                                    .id(123)
                                    .buttonStyle(.borderedProminent)
                                    .disabled(!(editor.selectedImage != nil &&  editor.selectedRoomStyle != nil))
                                
                                
                                
                                
                                
                            }.onDisappear{
                                selection = .defaultSyles
                                
                                
                            }
                            .alert("Grant Camera permission", isPresented: $showCameraPermissionAlert, actions: {
                                
                                Button("Enable Camera",role:.cancel) {
                                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(appSettings)
                                    }
                                }.tint(.accentColor)
                                
                          
                                
                                
                            }, message: {
                                Text("To transform your floor with photos you take, please allow access to your camera.")
                            })
                            
                            .onAppear{
                                
                                subscription.productIds = [ "B101","B102"]
                                
                                cameraStatus = checkCameraPermission()
                                permissionGranted = (cameraStatus == .authorized)
                            
                                creditVM.fetchCredits()
                                

                                do{
                                    
                                    
                                    let savedRequestId = try simpleKeychain.string(forKey: "requestId")
                                    
                                    editor.requestId   = savedRequestId
                                    
                                    
                                } catch {
                                    
                                    let uuid = UUID().uuidString
                                    editor.requestId = uuid
                                    
                                    do {
                                        
                                        try simpleKeychain.set( uuid, forKey: "requestId")
                                        
                                    } catch {
                                        
                                    }
                                    
                                }
                            }
                            
                            
                            .sheet(isPresented: $showTypeSelector, content: {
                                VStack{
                                    HStack{
                                        Spacer()
                                        Button {
                                            showTypeSelector = false
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 18, weight: .medium))
                                            
                                                .frame(width: 32, height: 32)
                                                .background(.ultraThinMaterial)
                                                .clipShape(Circle())
                                        }
                                        .buttonStyle(.plain)
                                        
                                    }.padding()
                                    
                                    Text("Room Type Selector")
                                        .fontWeight(.bold)
                                        .padding(.bottom)
                                    
                                    ScrollView {
                                        
                                        LazyVGrid(columns: [GridItem(),GridItem(),GridItem()]) {
                                            
                                            
                                            
                                            ForEach(RoomType.allCases, id: \.self) { roomType  in
                                                
                                                Button {
                                                    editor.selectedRoomType =  roomType
                                                    showTypeSelector = false
                                                    
                                                } label:{
                                                    
                                                    MainActionButton(image: roomType.icon, color: .gradientColor2, title: roomType.localizedName)
                                                    
                                                    
                                                    
                                                }
                                                
                                                
                                                
                                            }
                                        }
                                        
                                    }.padding(.horizontal)
                                    
                                    
                                    Spacer()
                                }
                            })
                            
                            
                            .sheet(isPresented: $showStyleSelector, content: {
                                VStack{
                                    HStack{
                                        Spacer()
                                        
                                        Text("Floor Design Selector")
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                        
                                        Button {
                                            showStyleSelector = false
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 18, weight: .medium))
                                            
                                                .frame(width: 32, height: 32)
                                                .background(.ultraThinMaterial)
                                                .clipShape(Circle())
                                        }
                                        .buttonStyle(.plain)
                                        
                                    }.padding()
                                    
                                    
                                    
                                    SelectionSwitcher(selection: $selection)
                                        .padding(.vertical)
                                    
                                    
                                    if (selection == .defaultSyles) {
                                        
                                        ScrollView {
                                            
                                            LazyVGrid(columns: [GridItem(),GridItem(),GridItem()]) {
                                                
                                                
                                                
                                                ForEach(FloorTileDesigns.allCases, id: \.self) { roomStyle  in
                                                    if ![FloorTileDesigns.image, FloorTileDesigns.custom].contains(roomStyle) {
                                                        
                                                        Button {
                                                            if !["ceramicGlossy","porcelainMatte", "marbleTile"].contains(roomStyle.rawValue)
                                                                && !subscription.isSubscribed {
                                                                
                                                                subscription.showPaymentSheet =  true
                                                                
                                                            } else {
                                                                editor.selectedRoomStyle =  roomStyle
                                                            }
                                                            
                                                            showStyleSelector = false
                                                            
                                                        } label:{
                                                            VStack {
                                                                
                                                                Image(roomStyle.rawValue)
                                                                    .resizable()
                                                                    .scaledToFill()
                                                                    .frame(width: layoutVM.isIpad ? 180 :  115,height: layoutVM.isIpad ? 150: 90)
                                                                
                                                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                                                
                                                                
                                                                Text(roomStyle.localizedName)
                                                                    .font(layoutVM.isIpad ? .headline : .footnote)
                                                                    .padding(.top,2)
                                                                    .foregroundStyle(.white)
                                                                    .lineLimit(1)
                                                                
                                                            }
                                                            .padding(.bottom)
                                                            .overlay {
                                                                if !["formalGarden","cottageGarden", "woodlandGarden"].contains(roomStyle.rawValue) && !subscription.isSubscribed {
                                                                    
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
                                                    }
                                                    
                                                    
                                                    
                                                }
                                            }
                                            
                                        }.padding(.horizontal)
                                        
                                    } else {
                                        
                                        
                                        
                                        VStack {
                                            MyTextEditor(editor: editor, isTextFieldFocused: $isTextFieldFocused, canSubmit: $canSubmit,title: String(localized: "Describe your floor design"), description:String(localized: "Tell us in detail how you want your landscape to look"))
                                            
                                            Button {
                                                
                                                
                                                editor.selectedRoomStyle = .custom
                                                editor.customStylePrompt =  editor.prompt
                                                
                                                editor.prompt = ""
                                                
                                                
                                                
                                                showStyleSelector = false
                                                
                                                
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
                                        }.padding(.horizontal)
                                        
                                        HStack{
                                            
                                            Text("Example Prompts")
                                                .fontWeight(.bold)
                                                .padding()
                                            
                                            Spacer()
                                        }
                                        
                                        
                                        ScrollView {
                                            
                                            VStack{
                                                
                                                ForEach(samplePrompts, id: \.self) { prompt in
                                                    
                                                    Text(prompt)
                                                        .font(.subheadline)
                                                        .padding()
                                                        .background{
                                                            Color(.secondarySystemBackground)
                                                        }
                                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                                        .padding(.bottom)
                                                        .onTapGesture {
                                                            editor.prompt =  prompt
                                                        }
                                                }
                                                
                                                
                                                
                                                
                                            }.padding(.horizontal)
                                            
                                            
                                        }
                                    }
                                    
                                    
                                    
                                    Spacer()
                                }
                            })
                            
                            
                            
                            
                            
                            
                            .sheet(isPresented: $showActionSelector) {
                                
                                
                                
                                
                                VStack {
                                    
                                    
                                    
                                    HStack{
                                        Spacer()
                                        Button {
                                            showActionSelector = false
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 18, weight: .medium))
                                            
                                                .frame(width: 32, height: 32)
                                                .background(.ultraThinMaterial)
                                                .clipShape(Circle())
                                        }
                                        .buttonStyle(.plain)
                                        
                                    }.padding()
                                    
                                    
                                    VStack{
                                        Text("Select Image Options")
                                            .fontWeight(.bold)
                                            .padding(.bottom)
                                        
                                        HStack{
                                            
                                            
                                            PhotosPicker(selection: $pickersItem,matching: .images){
                                                
                                                
                                                
                                                MainActionButton(image: "photo", color: .gradientColor2, title: String(localized:"Photos"))
                                                
                                                
                                                
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
                                                    
                                                    
                                                    
                                                    
                                                    //
                                                    editor.selectedImage = image.resized(toPercentage: 0.7)
                                                    
                                                    
                                                    showActionSelector = false
                                                    
                                                    
                                                    
                                                    pickersItem = nil
                                                    
                                                    
                                                    
                                                }
                                            }
                                            
                                            
                                            
                                            
                                            
                                            Button {
                                              
                                                if cameraStatus == .denied {
                                                    
                                                     showCameraPermissionAlert =  true
                                                    return
                                                }
                                                    
                                                    showCameraPicker =  true
                                                    
                                                    
                                
                                        
                                                
                                                
                                            } label: {
                                                
                                                MainActionButton(image: "camera", color: .gradientColor2, title: String(localized:"Camera"))
                                            }
                                            
                                            
                                            
                                            Button {
                                                
                                             showFilePicker =  true

                                            } label: {
                                                
                                                MainActionButton(image: "folder", color: .gradientColor2, title: String(localized:"Files"))
                                            }
                                            
                                            
                                            
                                            
                                        }
                                        
                                        HStack{
                                            Text("Sample Images")
                                                .fontWeight(.bold)
                                            Spacer()
                                        }.padding()
                                        
                                        ScrollView(.horizontal) {
                                            HStack {
                                                
                                                ForEach(SampleImages.allCases, id: \.self) { image in
                                                    
                                                    VStack{
                                                        
                                                        AvatarCard(image:image.rawValue)
                                                     
                                                        
                                                    }.onTapGesture {
                                                        editor.selectedImage = UIImage(named: image.rawValue)
                                                        showActionSelector = false
                                                        
                                                    }
                                                    
                                                }
                                            }.padding(.horizontal)
                                            
                                            
                                            
                                        }
                                        
                                        
                                        Spacer()
                                        
                                    }.padding(.vertical)
                                        .fullScreenCover(isPresented: $showCameraPicker) {
                                            
                                            CameraImagePicker(image: $editor.selectedImage ){ image in
                                                editor.selectedImage  = image
                                                showActionSelector = false
                                            }
                                            
                                        }
                                        .sheet(isPresented: $showFilePicker) {
                                            DocumentPicker() { urls in
                                                
                                                if let url = urls.first {
                                                    loadImage(from: url ) { loadedImage in
                                                        editor.selectedImage  = loadedImage
                                                        showActionSelector = false
                                                    }
                                                }
                                            }
                                        }
                                    
                                    
                                    
                                    
                                    
                                    
                                }.presentationDetents([ layoutVM.isIpad ?  .large :  .medium])
                                
                                
                                
                                
                            }
                            
                            
                            
                            
                            
                            Spacer()
                            
                            
                            
                        }.frame(maxWidth:720)
                        
                        .preferredColorScheme(.dark)
                        .onChange(of: editor.result, { oldValue, newValue in
                            
                            path.append( editor.result)
                            
                            
                        })
                        
                        
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing){
                                
                                Button{
                                    
                                    path.append("Settings")
                                    
                                } label: {
                                    
                                    Image(systemName: "slider.horizontal.3")
                                        .font(.title2)
                                        .padding(5)
                                    
                                }
                                
                                
                            }
                            
                            if !subscription.isSubscribed {
                                ToolbarItem(placement: .topBarLeading){
                                    
                                    Button{
                                        
                                        subscription.showPaymentSheet =  true
                                        
                                    } label: {
                                        HStack{
                                            
                                            Image("crown")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                                .padding(5)
                                            Spacer()
                                        }
                                        
                                    }
                                    
                                    
                                }
                                
                            }
                            
                            ToolbarItem(placement: .principal){
                                
                               Text("Landscape Design")
                                    .fontWeight(.bold)
                                
                                
                            }
                            
                            
                            
                            
                        }.preferredColorScheme(.dark)
                        
                        
                            .navigationDestination(for: GeneratedResult.self , destination: {  result in
                                
                                ResultsView()
                                
                            })
                        
                        
                        
                            .navigationDestination(for: String.self){ text in
                                
                                SettingsView(webPageUrl: $webPageUrl, canShowWebView: $canShowWebView)
                            }
                        
                        
                            .fullScreenCover(isPresented: $subscription.showPaymentSheet){
                                MyPurchaseView(isPresented: $subscription.showPaymentSheet)
                            }
                        
                            .onAppear {
                                
                                
                                editor.isSubscribed = subscription.isSubscribed ? "1" : "0"
                                
                            }
                        
                        
                        
                            .alert(editor.errorMessage, isPresented: $editor.canShowErrorAlert) {
                                Button("Done", role: .cancel) {}
                                
                            }
                        
                            .sheet(isPresented: $canShowWebView){
                                
                                
                                
                                WebPageView(webURL: $webPageUrl)
                                
                                
                                
                                
                                
                            }
                        
                        
                        
                            .padding(.horizontal)
                        
                        
                        
                        if editor.isLoading {
                            LoadingView()
                        }
                        
                        
                        
                    }
                    
                    
                }
            }
            
        }
        
    }
    
    
    
    
    // Camera Image Picker
    struct CameraImagePicker: UIViewControllerRepresentable {
        @Binding var image: UIImage?
        var onImagePicked: (UIImage) -> Void
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            var parent: CameraImagePicker

            init(_ parent: CameraImagePicker) {
                self.parent = parent
            }

            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                if let selectedImage = info[.originalImage] as? UIImage {
                    parent.image = selectedImage
                    parent.onImagePicked(selectedImage)
                }
                picker.dismiss(animated: true)
            }

            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = context.coordinator
            return picker
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    }

  func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
      DispatchQueue.global().async {
          if let data = try? Data(contentsOf: url),
             let image = UIImage(data: data) {
              DispatchQueue.main.async {
                  completion(image)
              }
          } else {
              DispatchQueue.main.async {
                  completion(nil)
              }
          }
      }
  }
}




#Preview {
    ContentView()
        .environmentObject(EditorViewModel())
        .environmentObject(Subscription())
        .environmentObject(LayoutManager())

        
}
