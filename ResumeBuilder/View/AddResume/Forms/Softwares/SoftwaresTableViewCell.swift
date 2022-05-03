//
//  SoftwaresTableViewCell.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 4/2/2022.
//

import UIKit
import CoreData


class SoftwaresTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static var cellId = "softwareCell"
    var keyboardReturnTapped: (()->())?
    var objectId: NSManagedObjectID? = nil
    
    var software: Softwares? {
        didSet {
            guard let software = software else { return }
            softwareTitleTextField.text = software.title
            ratingStackView.starsRating = Int(software.level)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let textField = textField as! AutocompleteField
        textField.text = textField.suggestion
        
        keyboardReturnTapped?()
        return false
    }
    
    
    //MARK: - Init Subviews
    lazy var softwareTitleTextField: AutocompleteField = {
        let textField = AutocompleteField()

        textField.accessibilityLabel = "software-textfield"
        textField.placeholder = "Excel..."
        textField.autocorrectionType = .no
        textField.font = UIFont(name: Theme.nunitoSansRegular, size: 15)
        textField.borderStyle = .none
        textField.delegate = self
        textField.tag = 0
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.backgroundColor = .apBackground
        textField.textColor = .apTintColor
        textField.tintColor = .apTintColor
        
        textField.clearButtonMode = .never
        textField.contentVerticalAlignment = .center
        textField.returnKeyType = .continue
        textField.keyboardType = .alphabet
        
        if let image = UIImage(named: "software")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal) {
            textField.setLeftView(image: image)
            textField.leftViewPadding = 30
        }
        
        textField.autocapitalizationType = .words
        textField.suggestions = softwaresSuggestions
        
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
        
        accessibilityLabel = "Software-Cell"
        
        contentView.addSubview(softwareTitleTextField)
        contentView.addSubview(ratingStackView)
        
        NSLayoutConstraint.activate([
            softwareTitleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            softwareTitleTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            softwareTitleTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            
            ratingStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            ratingStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
