//
//  AvatarViewModel.swift
//  AvatarCreator
//
//  Created by henry on 07/02/2025.
//

import SwiftUI
import SimpleKeychain

import Photos

@MainActor
class EditorViewModel: ObservableObject {
    
    @Published var  generatedResult:GeneratedImages  = GeneratedImages(images: [])
    @Published var result:GeneratedResult = GeneratedResult(image: "")
    @Published var  isLoading  =  false;
    @Published var  taskComplete = false
    @Published var  errorMessage:String = ""
    @Published var  alertMessage:String = ""
    @Published var  canShowErrorAlert:Bool = false
    @Published var  canShowMessageAlert:Bool = false
    @Published var  canRedirect:Bool = true
    @Published var  prompt:String = ""
    @Published var  canSubmit = false
    @Published var  selectedStyles:String = ""
    @Published var  loadingHasProgress =  false
    @Published var  requestId:String = ""
    @Published var  isSubscribed:String = "0"
    
    @Published var  size:ImageSizes = .square
    @Published var uploadKey:String = ""
    @Published var edittedImage:String = ""
    @Published var selectedImage:UIImage? = nil
    @Published var selectedRoomType:RoomType? = nil
    @Published var selectedRoomStyle:FloorTileDesigns? = nil
    @Published var selectedStyleImage:UIImage? = nil
    @Published var customStylePrompt:String?
    
    
    let simpleKeychain = SimpleKeychain()
    

    
    func editImage() async throws {
  
    
            self.isLoading = true
        
       
      
        guard let serverUrl =  URL(string: "https://whitebg.net/api/edit-image?playtform=ios&req=\(self.requestId)&pro=\(self.isSubscribed)") else {
            
            throw NetworkError.InvalidURL
        }
        
        var request = URLRequest(url: serverUrl)
   
        
        request.httpMethod = "POST"
   
            // Specify headers if needed
            let boundary = UUID().uuidString
            
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var body = Data()
            
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(self.result.image)\r\n".data(using: .utf8)!)
        
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"key\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(self.uploadKey)\r\n".data(using: .utf8)!)
        
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"prompt\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(self.prompt)\r\n".data(using: .utf8)!)
        
        
  
        do{
            
        
            
            request.httpBody = body
            
            let (data, response)  =   try await URLSession.shared.data(for: request)
            
//       
//           
//            let jsonString = String(data: data, encoding: .utf8)
//          
//            print(jsonString,self.uploadKey.key)
////
//        
            
            
            guard let response =  response as? HTTPURLResponse, response.statusCode == 200 else {
                
                if let response =  response as? HTTPURLResponse, response.statusCode == 400 {
                    
                    throw NetworkError.InvalidRequest
                    
                }else{
                    
             
                    
                    throw NetworkError.invalidResponse
                }
                
              
            }
            
            
      
            
            do {
                
                let decoder = JSONDecoder();
                
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let output =  try decoder.decode(UploadedImage.self, from: data)
                
                    
                    self.uploadKey = output.key
                    self.edittedImage =  output.image
                    self.isLoading =  false
               
                
            } catch {
                
                throw NetworkError.InvalidData
                
            }
            
            
            
            
        }catch  {
            
            print(error.localizedDescription)
             
            throw NetworkError.NoNetwork
        }
        
   
    }
    
    
    
    
    func upscaleImage() async throws {
  
    
            self.isLoading = true
        
       
      
        guard let serverUrl =  URL(string: "https://whitebg.net/api/upscale-image?playtform=ios&req=\(self.requestId)&pro=\(self.isSubscribed)&test=1") else {
            
            throw NetworkError.InvalidURL
        }
        
        var request = URLRequest(url: serverUrl)
   
        
        request.httpMethod = "POST"
   
            // Specify headers if needed
            let boundary = UUID().uuidString
            
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var body = Data()
            
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(self.result.image)\r\n".data(using: .utf8)!)
        
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"key\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(self.uploadKey)\r\n".data(using: .utf8)!)
        
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"prompt\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(self.prompt)\r\n".data(using: .utf8)!)
        
        
  
        do{
            
        
            
            request.httpBody = body
            
            let (data, response)  =   try await URLSession.shared.data(for: request)
            
//
//
//            let jsonString = String(data: data, encoding: .utf8)
//
//            print(jsonString,self.uploadKey.key)
////
//
            
            
            guard let response =  response as? HTTPURLResponse, response.statusCode == 200 else {
                
                if let response =  response as? HTTPURLResponse, response.statusCode == 400 {
                    
                    throw NetworkError.InvalidRequest
                    
                }else{
                    
             
                    
                    throw NetworkError.invalidResponse
                }
                
              
            }
            
            
      
            
            do {
                
                let decoder = JSONDecoder();
                
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let output =  try decoder.decode(UploadedImage.self, from: data)
                
                    
                    self.uploadKey = output.key
                    self.edittedImage =  output.image
                    self.isLoading =  false
               
                
            } catch {
                
                throw NetworkError.InvalidData
                
            }
            
            
            
            
        }catch  {
            
            print(error.localizedDescription)
             
            throw NetworkError.NoNetwork
        }
        
   
    }
    
    
    
    
    func uploadImage  () async throws {
        
      
            self.isLoading = true
        
        guard let style =  self.selectedRoomStyle  else {
            
            throw NetworkError.InvalidData
            
        }
        
        
        
        
        guard let url =  URL(string: "https://whitebg.net/api/redesign-floor?playtform=ios&req=\(self.requestId)&pro=\(self.isSubscribed)") else {
            
            throw NetworkError.InvalidURL
        }
        
        let prompt =  style.prompt
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
   
            // Specify headers if needed
            let boundary = UUID().uuidString
            
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var body = Data()
            
       
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"style\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(style.rawValue)\r\n".data(using: .utf8)!)
        
        

        

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"prompt\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(prompt)\r\n".data(using: .utf8)!)
        
        

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"custom\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(self.customStylePrompt ?? "")\r\n".data(using: .utf8)!)
        
        
        
        
        
        
        
            // Add the image to the body
        
        if let image = selectedImage {
            
            if let imageData = image.jpegData(compressionQuality:0.7) {
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
              
                  body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            }
            
            
        
        }
        
        
        // Add the image to the body
    
    if let image = selectedStyleImage {
        
        if let imageData = image.jpegData(compressionQuality:0.7) {
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
          
              body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        }
        
        
    
    }
  
        
        
  
        do{
            
        
            
            request.httpBody = body
            
            let (data, response)  =   try await URLSession.shared.data(for: request)
            
    
            
     
                 let jsonString = String(data: data, encoding: .utf8)
     
                 print(jsonString)
                 
            
            guard let response =  response as? HTTPURLResponse, response.statusCode == 200 else {
                
                if let response =  response as? HTTPURLResponse, response.statusCode == 400 {
                    
                    throw NetworkError.InvalidRequest
                    
                }else{
                    
                    throw NetworkError.invalidResponse
                }
                
              
            }
            
        
            
         
            
            do {
                
                let decoder = JSONDecoder();
                
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let output =  try decoder.decode(UploadedImage.self, from: data)
                
                    
                    self.uploadKey = output.key
                    self.result.image =  output.image
                    self.isLoading =  false
               
                
            } catch {
                
                throw NetworkError.InvalidData
                
            }
            
            
            
        }catch  {
             
            throw NetworkError.NoNetwork
        }
    }
    
    
    
    func downloadImage (url: String) async throws -> UIImage {
        
        guard let url = URL(string: url) else {
            throw NetworkError.InvalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response =  response as? HTTPURLResponse, response.statusCode == 200 else {
            
            if let response =  response as? HTTPURLResponse, response.statusCode == 400 {
                
                throw NetworkError.InvalidRequest
                
            }else{
                
                throw NetworkError.invalidResponse
            }
            
          
        }
        
        guard  let uiImage = UIImage(data: data) else{
            throw  NetworkError.SaveFailed
        }
        
        return uiImage
        
    }
    
    


    
    func saveImageToGallery (url:String, hasWatermark:Bool, completed:  @escaping () -> Void ) async {
    
     
        let imageSaver = ImageSaver {
            completed()
        }
     
            self.isLoading =  true
        
        
        
        do {
            
            let result = try await  downloadImage(url:url)
            
            imageSaver.saveImage(result, withWatermark: hasWatermark)
          
               
            
            
        } catch {
            
          
                self.isLoading =  false
                self.errorMessage = error.localizedDescription
                self.canShowErrorAlert = true
            
            
            
        }
        
       
        
    }
    
    

    
    func shareImage(from url: URL) {
        
        Task {
            do {
              
                    self.isLoading =  true
                
                
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                  
               
                        
                        self.shareMyImage(image)
                        self.isLoading =  false
                        
                    
                
                    
                } else {
                    self.isLoading =  false
                    print("Failed to create UIImage from data.")
                }
            } catch {
                self.isLoading =  false
                print("Error downloading image: \(error)")
            }
        }
    }


    
    private func shareMyImage(_ image: UIImage) {
         let activityVC = UIActivityViewController(
             activityItems: [image],
             applicationActivities: nil
         )
         
         // Get the current window scene
         guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootViewController = window.rootViewController else {
             return
         }
         
         // Handle iPad presentation
         if let popover = activityVC.popoverPresentationController {
             popover.sourceView = window
             popover.sourceRect = CGRect(x: window.bounds.midX,
                                       y: window.bounds.midY,
                                       width: 0,
                                       height: 0)
             popover.permittedArrowDirections = []
         }
         
         rootViewController.present(activityVC, animated: true)
     }
    
    
    
    func sendFeedback(text:String) async throws {

        
        
        
  
            self.isLoading = true
        
       
      
        guard let serverUrl =  URL(string: "https://whitebg.net/api/feedback?platform=ios&req=\(self.requestId)&pro=\(self.isSubscribed)") else {
            
            throw NetworkError.InvalidURL
        }
        
        var request = URLRequest(url: serverUrl)
        
        
        request.httpMethod = "POST"
   
        
                 // Specify headers if needed
                 let boundary = UUID().uuidString
                 
                 request.setValue("application/json", forHTTPHeaderField: "Accept")
                 request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                 var body = Data()
                 
             
             
             body.append("--\(boundary)\r\n".data(using: .utf8)!)
             body.append("Content-Disposition: form-data; name=\"text\"\r\n\r\n".data(using: .utf8)!)
             body.append("\(text)\r\n".data(using: .utf8)!)
        
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"app\"\r\n\r\n".data(using: .utf8)!)
        body.append("Cartoon Photo Editor - IOS \r\n".data(using: .utf8)!)
   
      
        
  
        do{
            
        
            
            request.httpBody = body
            
            let (_, response)  =   try await URLSession.shared.data(for: request)
            
//            let jsonString = String(data: data, encoding: .utf8)
//            print(jsonString)
        
            guard let response =  response as? HTTPURLResponse, response.statusCode == 200 else {
                
                if let response =  response as? HTTPURLResponse, response.statusCode == 400 {
                    
                    throw NetworkError.InvalidRequest
                    
                }else{
                    
             
                    
                    throw NetworkError.invalidResponse
                }
                
              
            }
            
            
      
            
            
       
                self.isLoading = false
            
           

            
            
        }
   
    }
    
    func fetchImage (editorData:AIImageRequestBody, selectedImage:UIImage?) async throws -> GeneratedImages {
        
        guard let url =  URL(string: "https://whitebg.net/api/generate-image?playtform=ios&req=\(self.requestId)&pro=\(self.isSubscribed)") else {
            
            throw NetworkError.InvalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
   
            // Specify headers if needed
            let boundary = UUID().uuidString
            
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var body = Data()
            
      
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"prompt\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(editorData.prompt)\r\n".data(using: .utf8)!)
            
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"size\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(editorData.size)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"type\"\r\n\r\n".data(using: .utf8)!)
        body.append("cartoon\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"style\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(editorData.style)\r\n".data(using: .utf8)!)
        
        
            // Add the image to the body
        
        if let image = selectedImage {
            
            if let imageData = image.jpegData(compressionQuality:1) {
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
              
                  body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            }
            
            
        
        }
        
  
        
        
  
        do{
            
        
            
            request.httpBody = body
            
            let (data, response)  =   try await URLSession.shared.data(for: request)
            
    
            
            
            guard let response =  response as? HTTPURLResponse, response.statusCode == 200 else {
                
                if let response =  response as? HTTPURLResponse, response.statusCode == 400 {
                    
                    throw NetworkError.InvalidRequest
                    
                }else{
                    
                    throw NetworkError.invalidResponse
                }
                
              
            }
            
        
            
         
            
            do {
                
                let decoder = JSONDecoder();
                
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                return try decoder.decode(GeneratedImages.self, from: data)
                
                
            } catch {
                
                throw NetworkError.InvalidData
                
            }
            
            
            
        }catch  {
             
            throw NetworkError.NoNetwork
        }
   
    }
    
    
}
