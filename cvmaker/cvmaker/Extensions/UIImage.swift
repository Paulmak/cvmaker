//
//  UIImage.swift
//  cvmaker
//
//  Created by Pavel on 17.11.2025.
//

import UIKit

extension UIView {
    
    func renderAsImage() -> UIImage {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { ctx in
            self.layer.render(in: ctx.cgContext)
        }
    }
}
