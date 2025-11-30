//
//  WebView.swift
//  WhiteBackground
//
//  Created by henry on 30/11/2024.
//



import SwiftUI
import WebKit


struct WebView: UIViewRepresentable {

 let url: URL
    
func makeUIView(context: Context) -> WKWebView {
     
 return WKWebView()
     
 }
    
func updateUIView(_ webView: WKWebView, context: Context) {

 let request = URLRequest(url: url)
    
 webView.load(request)
 }
}

#Preview {
 WebView(url: URL(string: "https://dpsmiles.net/")!)
 .edgesIgnoringSafeArea(.all)
 .preferredColorScheme(.dark)
}
