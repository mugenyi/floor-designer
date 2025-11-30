//
//  PaylistsView.swift
//  AiTextToSpeech
//
//  Created by henry on 26/04/2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var webPageUrl:URL?
    @Binding var canShowWebView:Bool
    @EnvironmentObject var subscription:Subscription
    @EnvironmentObject var editor:EditorViewModel
    @EnvironmentObject var layoutVM:LayoutManager
    @State var feedbackText = ""
    @State var showAlert:Bool =  false
    @FocusState var isTextFieldFocused:Bool
    let appID =  "id6744259092"
    
    var settingsList:[Settings] = [
        Settings(name: String(localized: "Terms of Service"), icon: "text.justify.right", url: "https://whitebg.net/terms-of-service"),
        Settings(name:String(localized: "Privacy policy"), icon:"text.justify.left", url: "https://whitebg.net/privacy-policy")
    ]
    
    var body: some View {
        VStack{
            Text("Settings")
                .font(.title3)
                .fontWeight(.bold)
            
            List{
                
                Section("Legal") {
                    ForEach(settingsList) { item  in
                        
                        Button {
                            webPageUrl = URL(string: item.url)
                            canShowWebView = true
                            
                        } label: {
                            HStack {
                                Image(systemName: item.icon)
                                Text(item.name)
                            }
                        }

                     
                    }
                }
                
                
                Section("Feedback") {
                    VStack{
                        
                        TextField(text: $feedbackText,axis: .vertical) {
                            Text("Have a feature request or feedback? We'd love to hear from you! ")
                        }.lineLimit(8, reservesSpace: true)
                            .submitLabel(.done)
                            .focused($isTextFieldFocused)
                            .onChange(of: feedbackText) {
                         
                                
                                if feedbackText.last?.isNewline == .some(true) {
                                    feedbackText.removeLast()
                                
                                    isTextFieldFocused = false
                                }
                            }
                        
                        
                        
                        Button {
                            
                            Task{
                                do {
                                    try await editor.sendFeedback(text:feedbackText)
                                    feedbackText = ""
                                    showAlert =  true
                                    editor.isLoading =  false
                                } catch {
                                    
                                    editor.errorMessage = error.localizedDescription
                                    editor.canShowErrorAlert = true 
                                    editor.isLoading =  false
                                }
                            }
            
                            
                        } label: {
                            HStack{
                                Image(systemName: "checkmark.circle")
                                Text("Submit")
                            }.padding(.horizontal)
                                .padding(.vertical,5)
                        }.buttonStyle(.borderedProminent)
                            .disabled(feedbackText.isEmpty)
                    }.alert("Thank you for your feedback", isPresented: $showAlert) {
                        
                    }
                    
                }.padding(.bottom)
                    .scrollIndicators(.hidden)
                
                
                
                Section("Support our journey") {
                 
                        
                        Button {
                            
                            if let url = URL(string: "https://apps.apple.com/app/\(self.appID)?action=write-review") {
                                UIApplication.shared.open(url)
                            }
                            
                        } label: {
                            HStack {
                                Image(systemName:"star")
                                Text("Enjoying the app? Leave a 5 star review! ")
                            }
                        }
                        
                        
                        Button {
                            
                            shareApp()
                            
                        } label: {
                            HStack {
                                Image(systemName:"heart")
                                Text("Share with friends")
                            }
                        }
                    
                    
                }
                
                
                
                
                
                
            }.frame(maxWidth:700)
        }
    }
    
    struct Settings:Identifiable {
        var id:UUID = UUID()
        var name:String
        var icon:String
        var url :String
    }
    
    
    func shareApp() {
        guard let url = URL(string: "https://apps.apple.com/app/\(self.appID)") else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        // Present from root view controller
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
    
}

#Preview {
    SettingsView(webPageUrl: .constant(nil ), canShowWebView: .constant(false))
        .environmentObject(Subscription())
}
