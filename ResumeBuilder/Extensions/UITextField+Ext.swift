//
//  UITextField+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 29/12/2021.
//

import UIKit


extension UITextField {
    internal func addBottomBorder(height: CGFloat = 1.0, color: UIColor = .black) {
        let borderView = UIView()
        borderView.accessibilityLabel = "TextFieldBottomBorder"
        borderView.backgroundColor = color
        borderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderView)
        
        NSLayoutConstraint.activate([
                borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
                borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                borderView.heightAnchor.constraint(equalToConstant: height)
            ])
    }
    
    func setLeftView(image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 0, width: 14, height: 14))
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 15))
        iconContainerView.addSubview(iconView)
        
        leftView = iconContainerView
        leftViewMode = .always
        self.tintColor = .saltBoxLight
    }

}



class customFormField: UITextField {
    
    var LCtitle: String = "..."
    
    convenience init(LCtitle: String, topText: String? = nil, border: Bool = true) {
        self.init(frame: .zero)
        
        self.LCtitle = LCtitle
        
        if let topText = topText {
            
            let topText: UILabel = {
                let label = UILabel()
                
                label.attributedText = NSAttributedString(string: topText,
                      attributes: [
                        .font: UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any,
                        .foregroundColor: UIColor.apTintColor
                                  ])
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            
            addSubview(topText)
            NSLayoutConstraint.activate([
                topText.bottomAnchor.constraint(equalTo: topAnchor, constant: 0),
                topText.leadingAnchor.constraint(equalTo: leadingAnchor),
                topText.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }
        
        let attributedPlaceHodler = NSAttributedString(string: LCtitle, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .strokeColor : UIColor.apTextFieldHolder ])
        
        attributedPlaceholder = attributedPlaceHodler
        
        if border == true {        
            addBottomBorder(height: 1.5, color: .apTextFieldBorder)
        }
        
        textColor = .apTextFieldTextColor
        font = UIFont(name: Theme.nunitoSansSemiBold, size: 14)
        
        tintColor = .apTextFieldHolder
        
        autocorrectionType = .no
        returnKeyType = .continue
        keyboardType = .alphabet
        clearButtonMode = .whileEditing
        autocapitalizationType = .words
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}


