//
//  LayoutManager.swift
//  AiTextToSpeech
//
//  Created by henry on 14/05/2025.
//

import SwiftUI

class LayoutManager:ObservableObject {
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    @Published var isIpad:Bool = false
    @Published var deviceLang = ""
    
    init(showToast: Bool = false, toastMessage: String = "", showErrorAlert: Bool = false, errorMessage: String = "", isIpad: Bool =  false) {
        self.showToast = showToast
        self.toastMessage = toastMessage
        self.showErrorAlert = showErrorAlert
        self.errorMessage = errorMessage
        self.isIpad = isIpad
        
        let myWidth = UIScreen.main.bounds.width
        if myWidth > 600 {
            self.isIpad = true
        }
        
   
        if let deviceLanguage = Locale.preferredLanguages.first {
        
            self.deviceLang = String(deviceLanguage.prefix(2))
            
        }
        
    }
    
    
}
