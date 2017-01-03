//
//  Extensions.swift
//  FlipTheBlindsNonsense
//
//  Created by Joel Bell on 11/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

enum SliceType {
    
    case horizontal
    case vertical
    
}

extension UIImage {
    
    func generateImage(slices: Int, type: SliceType) -> [UIImage] {
        
        var imageSlices: [UIImage] = []
        let imageRef = self.cgImage
        
        let multiplier = CGFloat(imageRef!.width) / self.size.width
        
        switch type {
        case .horizontal:
            
            let rectHeight = self.size.height * multiplier / CGFloat(slices)
            let rectWidth = self.size.width * multiplier
            
            for i in 0..<slices {
                
                let rectY: CGFloat = rectHeight * CGFloat(i)
                let frame = CGRect(x: 0, y: rectY, width: rectWidth, height: rectHeight)
                let slicedImageRef = imageRef?.cropping(to: frame)
                let imageSlice = UIImage(cgImage: slicedImageRef!)
                imageSlices.append(imageSlice)
            }
        case .vertical:
            
            let rectHeight = self.size.height * multiplier
            let rectWidth = self.size.width * multiplier / CGFloat(slices)
            
            for i in 0..<slices {
                
                let rectX: CGFloat = rectWidth * CGFloat(i)
                let frame = CGRect(x: rectX, y: 0, width: rectWidth, height: rectHeight)
                let slicedImageRef = imageRef?.cropping(to: frame)
                let imageSlice = UIImage(cgImage: slicedImageRef!)
                imageSlices.append(imageSlice)
            }
        }
        
        return imageSlices
        
    }
    
}

extension UIView {
    
    func drawImage() -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: (self.bounds.size))
        return renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            
        }
    }
    
    func renderImage() -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: (self.bounds.size))
        return  renderer.image { ctx in
            self.layer.render(in: ctx.cgContext)
            
        }
        
    }
    
}


