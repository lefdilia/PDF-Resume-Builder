//
//  AdditionalInformationVC.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 3/2/2022.
//

import UIKit
import CoreData


class AdditionalInformationVC: UIViewController, initialObjectDataSource {
    
    var presentingMainSection: Bool?
    var objectId: NSManagedObjectID?
    
    var initialObject: Initial? {
        didSet{
            if let additionalInformations = initialObject?.additionalInformation?.allObjects.first as? AdditionalInformation {
                
                objectId = additionalInformations.objectID
                
                if let additionalInformationsText = additionalInformations.text {
                    
                    self.additionalInformationTextView.text = additionalInformationsText.trimmingCharacters(in: .whitespacesAndNewlines)
                    textViewDidChange(self.additionalInformationTextView)
                }
            }
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    //MARK: - Previous Button
    lazy var previousVCButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back-arrow")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        let icon = NSTextAttachment()
        let image = UIImage(named: "information")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
        icon.image = image
        icon.bounds = CGRect(x: 0, y: -5, width: image?.size.width ?? 5 , height: image?.size.height ?? 5)
        let attachement = NSAttributedString(attachment: icon)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(attachement)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: "Additional Information", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 18) as Any, .foregroundColor : UIColor.apTintColor as Any]))
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "Showcase your additional information to an employer.", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var labelPlaceholder: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.attributedText = NSMutableAttributedString(string: "Please add your additional information here", attributes: [.font : UIFont(name: Theme.nunitoSansItalic, size: 14) as Any, .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.5) as Any ])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var additionalInformationTextView: UITextView = {
        let textView = UITextView()
        
        textView.autocorrectionType = .no
        textView.backgroundColor = .apBackground

        textView.textColor = .apTintColor
        textView.tintColor = .apTintColor
        textView.font = UIFont(name: Theme.nunitoSansSemiBold, size: 14)

        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 0.8
        textView.layer.borderColor = UIColor.apBorderJobCell.cgColor
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.keyboardType = .alphabet
        textView.returnKeyType = .done
        
        textView.smartDashesType = .yes
        textView.delegate = self

        textView.addSubview(labelPlaceholder)
        labelPlaceholder.topAnchor.constraint(equalTo: textView.topAnchor, constant: 6).isActive = true
        labelPlaceholder.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5).isActive = true
        labelPlaceholder.widthAnchor.constraint(equalTo: textView.widthAnchor, multiplier: 0.95).isActive = true

        return textView
    }()
    
    //MARK: - Final Buttons
    lazy var continueButton: UIButton = {
        var button = UIButton(type: .system)
        let imgsz = UIImageView()
        imgsz.accessibilityLabel = "ContinueButtonImage"
        imgsz.image = UIImage(named: "arrow-right")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        imgsz.contentMode = .scaleAspectFit
        imgsz.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "Save & Continue", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any, .foregroundColor : UIColor.white as Any ])
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = .apContinueButton
        button.layer.cornerRadius = 3
        button.addSubview(imgsz)
        imgsz.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        imgsz.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        var button = UIButton(type: .system)
        let uColor = UIColor.apTintColor.withAlphaComponent(0.8)
        
        let attributedText = NSMutableAttributedString(string: "Back", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor : uColor as Any])
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.apBorderJobCell.cgColor
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()

    lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backButton, continueButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually

        continueButton.widthAnchor.constraint(equalToConstant: 150).isActive = true

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    @objc func didTapContinue(){
        if let additionalInformations = additionalInformationTextView.text {
                       
            let additionalInformationModel = AdditionalInformationModel(initialObject: initialObject, objectId: objectId, status: true, text: additionalInformations)
           
            CoreDataManager.shared.setupAdditionalInformations(options: additionalInformationModel) { [weak self] _ in
                self?.didTapBackButton()
            }
        }
    }

    @objc func didTapBackButton(){
        if let target = popTo(MainSectionVC.self), target == false {
            let _initVC = MainSectionVC()
            _initVC.initialObject = initialObject
            self.navigationController?.pushViewController(_initVC, animated: true)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        backButton.backgroundColor = .apBackground
        backButton.layer.borderColor = UIColor.apBorderJobCell.cgColor
        
        additionalInformationTextView.layer.borderColor = UIColor.apBorderJobCell.cgColor
        additionalInformationTextView.textColor = .apTintColor
        additionalInformationTextView.tintColor = .apTintColor
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .apBackground
        
        if presentingMainSection == true && initialObject?.status == true {
            //Update
            let attributedText = NSMutableAttributedString(string: "Update", attributes: [
                .font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any,
                .foregroundColor: UIColor.white as Any])
            continueButton.backgroundColor = .apContinueButton
            continueButton.setAttributedTitle(attributedText, for: .normal)
        }
        
        backButton.backgroundColor = .apBackground
        backButton.layer.borderColor = UIColor.apBorderJobCell.cgColor
        
        //Hide keyboard after Edit
        view.hideKeyboard()
        
        //Init-Subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let bottomAnchor = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        bottomAnchor.priority = UILayoutPriority(250)
        
        let centerYAnchor = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        centerYAnchor.priority = UILayoutPriority(250)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
                        
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            bottomAnchor,
            centerYAnchor,
        ])
        
        contentView.addSubview(previousVCButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(sloganLabel)
        
        contentView.addSubview(additionalInformationTextView)

        contentView.addSubview(buttonsStack)
        
        NSLayoutConstraint.activate([
            previousVCButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            previousVCButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                        
            titleLabel.topAnchor.constraint(equalTo: previousVCButton.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: previousVCButton.leadingAnchor, constant: 0),
            
            sloganLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            sloganLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            sloganLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            sloganLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),

        
            additionalInformationTextView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 40),
            additionalInformationTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            additionalInformationTextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            additionalInformationTextView.heightAnchor.constraint(equalToConstant: 300),
            

            buttonsStack.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: additionalInformationTextView.bottomAnchor, multiplier: 7.5),
            buttonsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
        ])
    }
}


extension AdditionalInformationVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        //Placeholder
        let newAlpha: CGFloat = textView.text.isEmpty ? 1 : 0
        if labelPlaceholder.alpha != newAlpha {
            UIView.animate(withDuration: 0.2) {
                self.labelPlaceholder.alpha = newAlpha
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
