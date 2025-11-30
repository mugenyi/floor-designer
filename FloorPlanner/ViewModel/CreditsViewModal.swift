//
//  CreditsViewModal.swift
//  RemoveText
//
//  Created by henry on 04/04/2025.
//

import SwiftUI
import SimpleKeychain

class CreditsViewModal:ObservableObject {
    
    @Published var currentUsage = 0
    
    let simpleKeychain = SimpleKeychain()
    
    func fetchCredits()  {
        
                
            do {

                let credits = try simpleKeychain.string(forKey: "credits")
                 currentUsage = Int(credits) ?? 0
                
                
            } catch {
                
                
                do {
                    
                    try simpleKeychain.set(String(0), forKey: "credits")
                    
                }catch{
                    
                }
                
            }
          
        
    }
    
    func increaseCredit (by:Int =  1) {
       
         currentUsage  =  currentUsage +  by
       
        do {
            
            try simpleKeychain.set(String(currentUsage), forKey: "credits")
            
        }catch{
            print("Failed to store data")
        }
        
    }
    
    
    
    func deccreaseCredit (by:Int =  1) {
        currentUsage  =  currentUsage - by
      
        do {
            
            try simpleKeychain.set(String(currentUsage), forKey: "credits")
            
        }catch{
            print("Failed to store data")
        }
        
    }
    
    
    func resetCredits() {
        do {
            
            try simpleKeychain.set(String(0), forKey: "credits")
            
        }catch{
            print("Failed to store data")
        }
        
        
    }
    
    
}
