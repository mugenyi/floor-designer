//
//  ProgressLoaderView.swift
//  WhiteBackground
//
//  Created by henry on 30/11/2024.
//
import SwiftUI

struct ProgressLoaderView: View {
    @State private var progress: Double = 0.0
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
    
        
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .padding()
                .scaleEffect(1.5) // Makes the progress bar larger
            
          
        }
        .padding()
        .onAppear {
            startProgress()
        }
        .onDisappear {
            stopProgress()
        }
    }
    
    private func startProgress() {
        stopProgress() // Ensure no duplicate timers
        progress = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            withAnimation {
                if progress < 1.0 {
                    progress += 0.005 // Increment progress
                } else {
                    timer.invalidate()
                }
            }
        }
    }
    
    private func stopProgress() {
        timer?.invalidate()
        timer = nil
    }
}

struct ProgressLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressLoaderView()
    }
}

