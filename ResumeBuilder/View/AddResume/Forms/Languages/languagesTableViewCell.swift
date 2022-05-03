//
//  languagesTableViewCell.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 26/1/2022.
//

import UIKit
import CoreData


class languagesTableViewCell: UITableViewCell, UITextFieldDelegate {

    static var cellId = "languageCell"
    var keyboardReturnTapped: (()->())?
    var objectId: NSManagedObjectID? = nil
    
    var language: Languages? {
        didSet {
            guard let language = language else { return }
            
            languageTitleTextField.text = language.title
            ratingStackView.starsRating = Int(language.level)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let textField = textField as! AutocompleteField
        textField.text = textField.suggestion

        keyboardReturnTapped?()
        return false
    }
    
    //MARK: - Init Subviews
    let languagesSuggestions = localLanguages()

    lazy var languageTitleTextField: AutocompleteField = {
        let textField = AutocompleteField()

        textField.accessibilityLabel = "language-textfield"
        textField.placeholder = "Language..."
        textField.autocorrectionType = .no
        textField.font = UIFont(name: Theme.nunitoSansRegular, size: 15)
        textField.borderStyle = .none
        textField.delegate = self
        textField.tag = 0
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.textColor = .apTextFieldTextColor
        textField.tintColor = .apTextFieldHolder

        textField.clearButtonMode = .never
        textField.contentVerticalAlignment = .center
        textField.returnKeyType = .continue
        textField.keyboardType = .alphabet
        if let image = UIImage(named: "language")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal) {
            textField.setLeftView(image: image)
            textField.leftViewPadding = 30
        }
        textField.autocapitalizationType = .words
        textField.suggestions = languagesSuggestions
        
        return textField
    }()
    
    lazy var ratingStackView: RatingController = {
        let _stack = RatingController()
        for _ in 0..<5 {
            let starButton = UIButton()
            starButton.translatesAutoresizingMaskIntoConstraints = false
            _stack.addArrangedSubview(starButton)
        }
        _stack.translatesAutoresizingMaskIntoConstraints = false
        return _stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                    
        backgroundColor = .apBackground
        selectionStyle = .none
        
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: contentView.frame.width / 4)
                
        accessibilityLabel = "language-Cell"
            
        contentView.addSubview(languageTitleTextField)
        contentView.addSubview(ratingStackView)
                
        NSLayoutConstraint.activate([
            languageTitleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            languageTitleTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            languageTitleTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            
            ratingStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            ratingStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
