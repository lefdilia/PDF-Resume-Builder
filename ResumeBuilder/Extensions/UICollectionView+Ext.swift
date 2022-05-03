//
//  UICollectionView+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 15/3/2022.
//

import UIKit


extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        
        backgroundColor = .apBackground
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))

        let attributedText = NSAttributedString(string: message.capitalized, attributes: [
            .font: UIFont(name: Theme.nunitoSansSemiBold, size: 18) as Any, .foregroundColor: UIColor.apTintColor])
        
        messageLabel.attributedText = attributedText
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restoreBgView(){
        
        self.backgroundView = nil
    }
    
}
