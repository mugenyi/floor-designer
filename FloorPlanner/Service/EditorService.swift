//
//  EditorService.swift
//  AnimeMaker
//
//  Created by henry on 07/01/2025.
//

import Foundation
import PhotosUI

class EditorService {
    

    
    
    
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
    
    
}
