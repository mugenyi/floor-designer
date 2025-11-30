//
//  SelectionSwitcher.swift
//  RemoveText
//
//  Created by henry on 31/12/2024.
//

import SwiftUI


enum SelectionTypes:String,CaseIterable {
    case defaultSyles
    case  customSyles
    case  image
    
}


struct SelectionSwitcher :View {
    @Binding var selection:SelectionTypes
    
  
    
    var body: some View {
        
        Picker(selection: $selection, label: Text("Selection type")) {
            ForEach(SelectionTypes.allCases, id: \.self){
        
                if $0 == .customSyles {
                    Text("Custom Style")
                }
                
                if $0 == .defaultSyles {
                    Text("Default Syles")
                }
                
                if $0 == .image {
                    Text("Add  Image")
                }
         
            }

        }.pickerStyle(.segmented)
            .padding(.horizontal)
        
    }
}
