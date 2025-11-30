//
//  AnimatedListView.swift
//  FilterPhotos
//
//  Created by henry on 18/03/2025.
//

import SwiftUI

struct AnimatedListView: View {
    // Sample data for the list
    let items = [
                String(localized:"Instant Landscape Transformation"),
                 String(localized:"Multiple Design Styles to Explore"),
                 String(localized:"Easily Tweak Results"),
                 String(localized:"High-Quality & Shareable Renders"),
    ]
    
    // State to track if the list is visible
    @State private var isListVisible = false
    
    // State to track which items should be visible (for sequential animation)
    @State private var visibleItems: [Bool] = []
    
    init() {
        // Initialize all items as hidden
        self._visibleItems = State(initialValue: Array(repeating: false, count: items.count))
    }
    
    var body: some View {
        VStack(spacing: 20) {
     
    
            if isListVisible {
                VStack(alignment: .leading){
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        HStack  {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color(.accent))
                            
                         
                            Text(item)
                            
                        }    .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .offset(x: visibleItems[index] ? 0 : 300)
                            .opacity(visibleItems[index] ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1),
                                       value: visibleItems[index])
                    }
                }
              
                .transition(.opacity)
                .animation(.easeIn, value: isListVisible)
            }else {
                VStack{
                    ProgressView()
                }
            }
            
           
        }.padding()
            .onAppear{
                toggleList()
            }
    }
    
    // Toggle the list visibility and animate items
    private func toggleList() {
        if !isListVisible {
            // Show the list first
            isListVisible = true
            
            // Then animate each item with a delay
            for index in 0..<items.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Small delay for the list to appear
                    animateItem(at: index)
                }
            }
        } else {
            // Reset animations first
            for index in 0..<visibleItems.count {
                visibleItems[index] = false
            }
            
            // Hide the list after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isListVisible = false
            }
        }
    }
    
    // Animate a single item with sequential timing
    private func animateItem(at index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
            visibleItems[index] = true
        }
    }
}

#Preview {
    AnimatedListView()
}
