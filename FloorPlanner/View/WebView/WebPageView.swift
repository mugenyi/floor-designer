//
//  WebPageView.swift
//  WhiteBackground
//
//  Created by henry on 30/11/2024.
//

import SwiftUI

struct WebPageView: View {
    @Binding var webURL:URL?
    @Environment(\.dismiss)  var dismiss
    
    var body: some View {
        HStack{
            Spacer()
            Button("Done") {
                dismiss()
            }.padding()
        }.background(Color(.black))
        if let webpageURL = webURL {
            WebView(url:webpageURL)
        }
        
   
    }
}

#Preview {
    
    @Previewable @State  var url = URL(string: "https://dpsmiles.net/privacy-policy")
    
   
    WebPageView(webURL:  $url)
}
