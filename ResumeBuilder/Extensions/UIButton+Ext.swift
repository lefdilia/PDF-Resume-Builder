//
//  UIButton+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 2/1/2022.
//

import UIKit


class dropDownButton: UIButton {
    let dropDownImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dropDown")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var title: String = "Menu"
    var textColor: UIColor = .apTintColor
    
    convenience init(title: String, textColor: UIColor = .tundora, fontAlpha: CGFloat = 0.4, contentAlignment: UIControl.ContentHorizontalAlignment = .leading, border: Bool = true) {
            self.init(frame: .zero)
    
        self.title = title
        self.textColor = textColor
        self.init(type: .system)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.baseForegroundColor = UIColor.apTintColor.withAlphaComponent(fontAlpha)
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 1, bottom: 2, trailing: 20)
            configuration = config
        }else{
            tintColor = UIColor.apTintColor.withAlphaComponent(fontAlpha)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 2, right: 20)
        }
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any])
        setAttributedTitle(attributedText, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        
        if border == true {
            addBorder(side: .bottom, color: .apTextFieldBorder, width: 1.5)
        }
        
        addSubview(dropDownImage)
        dropDownImage.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        dropDownImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 1).isActive = true
        dropDownImage.heightAnchor.constraint(equalToConstant: 6).isActive = true
        dropDownImage.widthAnchor.constraint(equalToConstant: 9).isActive = true

        contentHorizontalAlignment = contentAlignment
    }
}
