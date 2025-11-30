//
//  HomeScreen.swift
//  AnimeMaker
//
//  Created by henry on 31/12/2024.
//

import SwiftUI
import PhotosUI

struct MyTextEditor: View {
    @ObservedObject var editor:EditorViewModel
    @FocusState.Binding var isTextFieldFocused: Bool
    @Binding var  canSubmit:Bool
    var title = String(localized: "Describe what you want to edit")
    var description = String(localized: "Tell us in detail what you what to change in the image ")
    @State private var pickersItem:PhotosPickerItem?
    @StateObject var  promptViewModel = PromptViewModel()
  
 
  
    
       
    var body: some View {
        VStack{
        
        
            VStack{
                
                HStack{
                    
                    Text(title)
                        .foregroundStyle(editor.prompt.isEmpty ? .white : .white.opacity(0.5))
                    
                    Spacer()
                    
                    if !editor.prompt.isEmpty {
                        Button {
                            editor.prompt = ""
                            
                        } label: {
                            
                            Image(systemName: "xmark")
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                    
                }
                
                
                TextField(text: $editor.prompt,axis: .vertical) {
                    Text(description)
                }.lineLimit(6, reservesSpace: true)
                    .submitLabel(.done)
                    .focused($isTextFieldFocused)
                    
                    .onChange(of: editor.prompt) {
                        
                        if editor.prompt.count > 3 {
                            canSubmit = true
                        }else{
                            canSubmit = false
                        }
                        
                        
                   
                        
                        if editor.prompt.last?.isNewline == .some(true) {
                            editor.prompt.removeLast()
                        
                            isTextFieldFocused = false
                        }
                    }
                 

                
                 
//                HStack{
//                
//            
//                
//                    
//                    Spacer()
//                    
//                    Button {
//                        
//                  
//                        
//                        Task{
//                            
//                            await promptViewModel.getRandomPrompt(editor: editor)
//                            
//                        }
//                     
//                 
//                        
//                        
//                    } label: {
//                    
//                        Image(systemName: "lightbulb.min.fill")
//                            .font(.title)
//                    }
//               
//
//                }
                
                    
              
                
            }.overlay {
                
                if promptViewModel.isLoading {
                 
                    ProgressView()
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        
            
           
            
        
             
            
        } .onTapGesture {
            isTextFieldFocused = false // Dismiss keyboard
            
        }
        }
      
        
     
    }


#Preview {
    @Previewable @State var prompt = ""
    @Previewable @StateObject var editor = EditorViewModel()
    @FocusState  var isTextFieldFocused: Bool
    
    MyTextEditor(editor: editor
                 ,isTextFieldFocused: $isTextFieldFocused,
                 canSubmit: .constant(true))
        .preferredColorScheme(.dark)
}
