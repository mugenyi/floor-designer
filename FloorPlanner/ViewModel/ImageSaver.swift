//
//  ImageSaver.swift
//  AvatarCreator
//
//  Created by henry on 12/02/2025.

//
import UIKit
import Photos

class ImageSaver: NSObject {
    
    var compplete: ()-> Void
    
    init(complete: @escaping () -> Void) {
        self.compplete = complete
    }
    
    func saveImage(_ image: UIImage, withWatermark: Bool) {
        let finalImage = withWatermark ? applyWatermark(to: image) : image
        
        UIImageWriteToSavedPhotosAlbum(finalImage, self, #selector(saveCompleted), nil)
    }
    
    private func applyWatermark(to image: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)

        return renderer.image { context in
            image.draw(at: .zero)

            let watermarkText = "whitebg.net"
            let watermarkText2 = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""

            let fontSize = image.size.width * 0.04

            // Shadow setup
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.black.withAlphaComponent(0.8)
            shadow.shadowOffset = CGSize(width: 2, height: 2)
            shadow.shadowBlurRadius = 4

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize),
                .foregroundColor: UIColor.white,
                .shadow: shadow
            ]

            // Draw bottom-center watermark (watermarkText)
            let bottomTextSize = watermarkText.size(withAttributes: attributes)
            let bottomX = (image.size.width - bottomTextSize.width) / 2
            let bottomY = image.size.height * 0.80 - bottomTextSize.height / 2
            let bottomRect = CGRect(x: bottomX, y: bottomY, width: bottomTextSize.width, height: bottomTextSize.height)
            watermarkText.draw(in: bottomRect, withAttributes: attributes)

            // Draw top-left watermark (watermarkText2)
            let topTextSize = watermarkText2.size(withAttributes: attributes)
            let topX: CGFloat = 20
            let topY: CGFloat = 20
            let topRect = CGRect(x: topX, y: topY, width: topTextSize.width, height: topTextSize.height)
            watermarkText2.draw(in: topRect, withAttributes: attributes)
        }
    }



    

    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Save failed: \(error.localizedDescription)")
        } else {
            self.compplete()
        }
    }
}
