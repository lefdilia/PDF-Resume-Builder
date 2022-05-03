//
//  AccomplishmentsVC.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 4/2/2022.
//

import UIKit
import CoreData


class AccomplishmentsVC: UIViewController, initialObjectDataSource {
    
    var presentingMainSection: Bool?
    var objectId: NSManagedObjectID?
    
    var initialObject: Initial? {
        didSet{
            if let accomplishments = initialObject?.accomplishments?.allObjects.first as? Accomplishments {
                
                objectId = accomplishments.objectID
                
                if let accomplishmentsList = accomplishments.text {
                    
                    let _accomplishments = accomplishmentsList.map({"• \($0)"}).joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    self.accomplishmentsTextView.text = _accomplishments
                    textViewDidChange(self.accomplishmentsTextView)
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        let icon = NSTextAttachment()
        let image = UIImage(named: "accomplishments")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
        icon.image = image
        icon.bounds = CGRect(x: 0, y: -5, width: image?.size.width ?? 5 , height: image?.size.height ?? 5)
        let attachement = NSAttributedString(attachment: icon)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(attachement)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: "Accomplishments", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 18) as Any, .foregroundColor : UIColor.apTintColor as Any]))
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "Tell us about your accomplishments.", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
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
        label.attributedText = NSMutableAttributedString(string: "Please add your accomplishments information here", attributes: [.font : UIFont(name: Theme.nunitoSansItalic, size: 14) as Any, .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.5) as Any ])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var accomplishmentsTextView: UITextView = {
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
        
        textView.textContainer.lineBreakMode = .byWordWrapping

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
        
        let accomplishmentsList: [String] = accomplishmentsTextView.text.components(separatedBy: "\n")
            .map({ $0.replacingOccurrences(of: "•", with:"" ) })
            .map({ $0.replacingOccurrences(of: "^ {1,}", with: "", options: .regularExpression) })
            .filter({ !$0.isEmpty })
        
        if accomplishmentsList.count > 0 {
            let accomplishmentsModel = AccomplishmentsModel(initialObject: initialObject, objectId: objectId, status: true, text: accomplishmentsList)
                        
            CoreDataManager.shared.setupAccomplishments(options: accomplishmentsModel) { [weak self] _ in
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
        
        accomplishmentsTextView.layer.borderColor = UIColor.apBorderJobCell.cgColor
        accomplishmentsTextView.textColor = .apTintColor
        accomplishmentsTextView.tintColor = .apTintColor
    
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
        
        contentView.addSubview(accomplishmentsTextView)

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
        
            accomplishmentsTextView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 40),
            accomplishmentsTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            accomplishmentsTextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            accomplishmentsTextView.heightAnchor.constraint(equalToConstant: 300),
    
            buttonsStack.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: accomplishmentsTextView.bottomAnchor, multiplier: 7.5),
            buttonsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
        ])
    }
}


extension AccomplishmentsVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.text ?? ""
        
        if text.count >= 0 && text.prefix(1) != "•" && text != "\n" { //just begin here
            textView.text = "• "+text
        }
        
        var arraySentences = text.replacingOccurrences(of: "(^\n{1,}|\n+)", with: "\n", options: [.regularExpression]).components(separatedBy: "\n")
        
        if arraySentences.count == 2, arraySentences.filter({ !$0.isEmpty }).count == 0 {
           arraySentences = arraySentences.filter({ !$0.isEmpty })
        }
        
        //Fix enter between dotted List
        let msText = arraySentences.map({ _sentence in
            return _sentence.replacingOccurrences(of: "^(?!•)", with: "• ", options: [.regularExpression], range: nil)
        }).filter({ !$0.isEmpty }).filter({ $0 != "• " && $0 != "•" }).joined(separator: "\n")
        
        textView.text = "\(msText)"
        
        if text.suffix(1) == "\n" {
            let editedText = arraySentences.map { _sentence -> String in
                if _sentence ==  "• " { return "" }
                if _sentence.prefix(2) == "• " { return "\(_sentence)" }
                return "• \(_sentence)"
            }.filter({ !$0.isEmpty }).joined(separator: "\n")
            
            let stEditedText = editedText.replacingOccurrences(of: #"(•(\s+)?){2,}+"#, with: "• ", options: [.regularExpression], range: nil)
            textView.text = "\(stEditedText)"
        }
        
        //Placeholder
        let newAlpha: CGFloat = textView.text.isEmpty || arraySentences.count == 0 ? 1 : 0
        if labelPlaceholder.alpha != newAlpha {
            UIView.animate(withDuration: 0.2) {
                self.labelPlaceholder.alpha = newAlpha
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text == "" && range.length > 0 { //Backspace
            let _text = textView.text
            
            if textView.text == "• " || textView.text == "" {
                textView.text = ""
                return false
            }
                        
            if let tempText = _text, tempText.suffix(2) == "\n• "{ // test if space can be optional (+-)
                let editedText = tempText.components(separatedBy: "\n").filter({ $0 != "• " }).joined(separator: "\n")
                textView.text = "\(editedText)"
                return false
            }
        }
        
        return true
    }
}
