//
//  UploadUI.swift
//  FloorPlanner
//
//  Created by henry on 30/11/2025.
//
import SwiftUI

struct UploadUI: View {
    @Binding var isShowing:Bool
    @State private var selectedImage:UIImage?
    @State private var isLoading = false
    @EnvironmentObject var editor:EditorViewModel
    @State var showCameraPicker =  false
    @State private var showFilePicker = false
    
    var body: some View {
        
        ZStack {
        
            VStack {
                
                Text("Add a photo of the floor design")
                    .padding(.vertical)
                PhotoSelector(isLoading: $isLoading, selectedImage: $selectedImage)
                    .onChange(of: selectedImage) { oldValue, newValue in
                        
                        editor.selectedStyleImage =  selectedImage
                        editor.selectedRoomStyle = .image
                        editor.prompt = "image"
                        isShowing =  false
                        
                    }
                
                VStack{
                    Text("Other Options")
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    HStack {
                        
                        Button {
                            
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
                }.padding(.vertical)
                    .fullScreenCover(isPresented: $showCameraPicker) {
                        
                        CameraImagePicker(image: $selectedImage){ image in
                            editor.selectedStyleImage =  image
                            editor.selectedRoomStyle = .image
                            editor.prompt = "image"
                            isShowing =  false
                            
                        }
                        
                    }
                    .sheet(isPresented: $showFilePicker) {
                        DocumentPicker() { urls in
                            
                            if let url = urls.first {
                                loadImage(from: url ) { loadedImage in
                                    editor.selectedStyleImage = loadedImage
                                    editor.selectedRoomStyle = .image
                                    editor.prompt = "image"
                                    isShowing =  false
                                    
                                }
                            }
                        }
                    }
                
                
                
                
                
                
                
                
                
                
                Spacer()
            }
            
            
            if  editor.isLoading  {
                LoadingView()
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
