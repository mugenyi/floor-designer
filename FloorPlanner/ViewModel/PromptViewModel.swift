//
//  PromptViewModel.swift
//  AnimeMaker
//
//  Created by henry on 11/01/2025.
//

import Foundation
import SwiftUI

@MainActor
class PromptViewModel: ObservableObject {
    
    @Published var isLoading  = false
    @Published var  errorMessage:String = ""
    @Published var  canShowErrorAlert:Bool = false
    
    
    func getRandomPrompt (editor:EditorViewModel) async {
        let service =  PromptService()
      
          
            self.isLoading =  true
        
        
        do {
            
            
            let result =  try await service.fetchPrompt()
            
        
          
                editor.prompt = result.text
                self.isLoading =  false
            
            
        }catch {
            
           
                self.isLoading =  false
                self.errorMessage = error.localizedDescription
                self.canShowErrorAlert = true
            
            
        }
        
    }
    

}
