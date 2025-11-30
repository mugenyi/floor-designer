//
//  PromptService.swift
//  AnimeMaker
//
//  Created by henry on 11/01/2025.
//

import Foundation
import SwiftUI

class PromptService {
    
    
    func fetchPrompt() async throws -> Prompt {
        
        var lang = "en"
        
        if let deviceLanguage = Locale.preferredLanguages.first {
        
            lang = deviceLanguage
            
        }
        
        
        guard let url =  URL(string:"https://whitebg.net/api/random-prompt?lang=\(lang)&type=cartoon") else {
            
            throw NetworkError.InvalidURL
        }
        
        
        do {
            
            let (data,response)  =  try await URLSession.shared.data(from: url)
            
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
                
                return try decoder.decode(Prompt.self, from: data)
                
                
            } catch {
                
                throw NetworkError.InvalidData
                
            }
            
            
        } catch {
            
            throw NetworkError.invalidResponse
        }
        
        
        
    
    }
}
