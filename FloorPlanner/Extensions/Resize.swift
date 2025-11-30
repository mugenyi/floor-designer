//
//  Resize.swift
//  AnimeMaker
//
//  Created by henry on 12/01/2025.
//

import SwiftUI


extension UIImage {
    func resized(toPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        draw(in: CGRect(origin: .zero, size: canvasSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func resizedToMaxFileSize(maxFileSizeKB: CGFloat) -> UIImage? {
        var compression: CGFloat = 1.0
        let maxFileSize = maxFileSizeKB * 1024
        
        guard var imageData = jpegData(compressionQuality: compression) else { return nil }
        while imageData.count > Int(maxFileSize) && compression > 0 {
            compression -= 0.1
            if let compressedImage = UIImage(data: imageData),
               let data = compressedImage.jpegData(compressionQuality: compression) {
                imageData = data
            }
        }
        return UIImage(data: imageData)
    }
}

