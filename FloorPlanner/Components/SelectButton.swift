//
//  SelectButton.swift
//  FloorPlanner
//
//  Created by henry on 01/12/2025.
//

import SwiftUI

struct SelectButton: View {
    @EnvironmentObject var layoutVM:LayoutManager
    var body: some View {
        
        VStack{
            
            
            HStack {
                Image(systemName: "photo.badge.plus.fill")
                Text("Select Photo").padding(.leading,10)
            }.padding(10)
                .padding(.horizontal)
                .background(Color(.accent))
                .foregroundStyle(.white)
                .font( layoutVM.isIpad ? .title : .title3)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }.frame(width: layoutVM.isIpad ? 450 : 350, height: layoutVM.isIpad ? 300 :  200)
            .background{
                Color(.secondarySystemBackground)
                    .cornerRadius(20)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(style: StrokeStyle(lineWidth: 2,dash: [CGFloat(2)]))
            }
    }
}

#Preview {
    SelectButton()
}
