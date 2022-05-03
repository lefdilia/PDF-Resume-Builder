//
//  UIImage+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 11/11/2021.
//

import UIKit


extension UIImage {
    
    func withInset(_ insets: UIEdgeInsets) -> UIImage {
        let targetWidth = size.width + insets.left + insets.right
        let targetHeight = size.height + insets.top + insets.bottom
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        let targetOrigin = CGPoint(x: insets.left, y: insets.top)
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: targetOrigin, size: size))
        }.withRenderingMode(renderingMode)
    }
     
     func imageWithSize(_ size:CGSize) -> UIImage {
         var scaledImageRect = CGRect.zero
         
         let aspectWidth:CGFloat = size.width / self.size.width
         let aspectHeight:CGFloat = size.height / self.size.height
         let aspectRatio:CGFloat = min(aspectWidth, aspectHeight)
         
         scaledImageRect.size.width = self.size.width * aspectRatio
         scaledImageRect.size.height = self.size.height * aspectRatio
         scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
         scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
         
         UIGraphicsBeginImageContextWithOptions(size, false, 0)
         
         self.draw(in: scaledImageRect)
         
         let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         
         return scaledImage!
     }
     
    
    
}
