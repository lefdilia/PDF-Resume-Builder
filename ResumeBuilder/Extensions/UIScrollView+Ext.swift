//
//  UIScrollView+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 1/1/2022.
//

import UIKit


extension UIScrollView {
    
    func scrollToBottom(animated: Bool, toTop: Bool = false) {
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.height + self.adjustedContentInset.bottom - 10)
        self.setContentOffset(bottomOffset, animated: animated)
        
        if toTop == true {
            let topSafeArea = self.superview?.safeAreaInsets.top ?? 0.0
            let desiredOffset = CGPoint(x: 0, y: -self.contentInset.top - topSafeArea)
            self.setContentOffset(desiredOffset, animated: true)
        }
        
    }
}

