//
//  ImagePairView.swift
//  reimagine home ai
//
//  Created by Shafiq Kasumba on 10/04/2025.
//
import SwiftUI

struct ImagePairView: View {
    @State private var shakeDegrees: Double = 0
    @State private var shakeZoom: CGFloat = 1.0
    @State private var isAnimating = false
    @State private var currentPairIndex = 0
    @EnvironmentObject var subscription:Subscription
    
    
    let color = Color.accentColor
    
    // Timer for automatic cycling through pairs
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    func startShaking() {
        isAnimating = true
        withAnimation(Animation.easeInOut(duration: 0.3).repeatForever(autoreverses: true)) {
            shakeDegrees = 2
            shakeZoom = 1.03
        }
    }
    
    func nextPair() {
        withAnimation(.easeInOut(duration: 0.8)) {
            currentPairIndex = (currentPairIndex + 1) % subscription.inputImages.count
        }
    }
    
    var body: some View {
        VStack(spacing: 5) {
            // Current pair with transition
            imagePair(index: currentPairIndex)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.9)),
                    removal: .opacity.combined(with: .scale(scale: 1.1))
                ))
                .id(currentPairIndex) // This ensures SwiftUI treats it as a new view
                .animation(.easeInOut(duration: 0.8), value: currentPairIndex)
        }
        .frame(height: 150)
        .padding(.vertical, 20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                startShaking()
            }
        }
        .onReceive(timer) { _ in
            if ( subscription.originalImage == nil && subscription.outputImage == nil ) {
                nextPair()
            }
        }
    }
    
    @ViewBuilder
    func imagePair(index: Int) -> some View {
        HStack(alignment: .center, spacing: 10) {
            if let image = subscription.originalImage {
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                //.aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                
            } else {
                // Input image
                Image(subscription.inputImages[index])
                    .resizable()
                    .scaledToFill()
                //.aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                    .shadow(radius: 3)
            }
            
            // Arrow
            Image(systemName: "arrow.right")
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
            
            if let url = subscription.outputImage {
                
                
                    AsyncImage(url: url) { loadedImage in
                        loadedImage
                            .resizable()
                            .scaledToFill()
                        //.aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .scaleEffect(shakeZoom)
                            .rotationEffect(.degrees(shakeDegrees))
                        
                    
                    
                        
                    } placeholder: {
                    
                        VStack{
                            ProgressView()
                        }.frame(width: 150, height: 150)
                        

                    }
                
 
                
            } else {
                
                // Output image with animation
                Image(subscription.outputImages[index])
                    .resizable()
                    .scaledToFill()
                //.aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .scaleEffect(shakeZoom)
                    .rotationEffect(.degrees(shakeDegrees))
            }
        }
        .padding()
   
        
    }
}

struct ImageView: View {
    var body: some View {
        ImagePairView()
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
