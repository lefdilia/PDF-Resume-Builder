//
//  CustomSocialContainer.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 28/2/2022.
//

import UIKit

class CustomSocialContainer: UIView, UITextFieldDelegate {
        
    var handler: ((_ button: UIButton) -> ())?
    var pickerHanlder: ((_ button: UIButton) -> ())?
    var socialLinkTrigger: ((_ textfield: UITextField) -> ())?

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        socialLinkTrigger?(textField)
        return false
    }
    
    @objc func didTapClose(_ sender: UIButton){
        handler?(sender)
    }

    @objc func didTapSocialMenu(_ sender: UIButton){
        pickerHanlder?(sender)
    }

    override var tag: Int {
        didSet{
            cancelButton.tag = tag
            socialSourcesOptionMenu.tag = tag
            socialLinkTextField.tag = tag
        }
    }

    lazy var socialLinkTextField: customFormField = {
        let textField = customFormField(LCtitle: "")
        textField.delegate = self
        textField.accessibilityLabel = "SocialLinks"
        textField.returnKeyType = .next
        textField.autocapitalizationType = .none
        return textField
    }()
    
    lazy var socialSourcesOptionMenu: UIButton = {
        let button = UIButton(type: .custom)
        let image =  UIImage(named: "dropDown")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
        
        if #available(iOS 15, *) {
            
            var config = UIButton.Configuration.plain()
            config.image = image?.withRenderingMode(.alwaysOriginal)
            config.imagePadding = 10
            config.baseForegroundColor = .apTintColor.withAlphaComponent(0.7)
            config.imagePlacement = .trailing
            config.titleAlignment = .leading
            button.configuration = config
            
        } else {
            
            image?.withTintColor(.apTintColor.withAlphaComponent(0.6))
            button.setImage(image, for: .normal)
            button.semanticContentAttribute = .forceRightToLeft
            button.titleLabel?.textColor = .apTintColor.withAlphaComponent(0.7)
            
            button.imageEdgeInsets.left = 10
            button.titleEdgeInsets.right = 10
        }
        
        button.addTarget(self, action: #selector(didTapSocialMenu(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addBorder(side: .bottom, color: .gallery, width: 1)

        button.accessibilityLabel = "socialLabel"

        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "trash.fill", withConfiguration: UIImage.SymbolConfiguration.init(scale: .medium))?.withTintColor(.apTrashButton).withRenderingMode(.alwaysOriginal)
         
         if #available(iOS 15.0, *) {
             var config = UIButton.Configuration.filled()
             config.baseBackgroundColor = .clear
             config.buttonSize = .large
             config.image = image
             button.configuration = config
         } else {
             button.setImage(image, for: .normal)
         }
       
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    convenience init() {
        self.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(socialLinkTextField)
        addSubview(socialSourcesOptionMenu)
        addSubview(cancelButton)

        NSLayoutConstraint.activate([

            socialLinkTextField.topAnchor.constraint(equalTo: topAnchor),
            socialLinkTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            socialLinkTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            socialLinkTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            socialLinkTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),

            socialSourcesOptionMenu.topAnchor.constraint(equalTo: socialLinkTextField.topAnchor),
            socialSourcesOptionMenu.leadingAnchor.constraint(equalTo: socialLinkTextField.trailingAnchor, constant: 5),
            socialSourcesOptionMenu.bottomAnchor.constraint(equalTo: socialLinkTextField.bottomAnchor),

            cancelButton.leadingAnchor.constraint(equalTo: socialSourcesOptionMenu.trailingAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5),
            cancelButton.centerYAnchor.constraint(equalTo: socialSourcesOptionMenu.centerYAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 20),

        ])

    }

}
