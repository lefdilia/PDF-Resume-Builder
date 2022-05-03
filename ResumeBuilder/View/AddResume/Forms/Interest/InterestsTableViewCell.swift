//
//  InterestsTableViewCell.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 21/1/2022.
//

import UIKit
import CoreData


class InterestsTableViewCell: UITableViewCell, UITextFieldDelegate {

    static var cellId = "interestsCell"
    var keyboardReturnTapped: (()->())?
    var objectId: NSManagedObjectID? = nil
    
    var interest: Interests? {
        didSet {
            guard let interest = interest else { return }
            interestTitleTextField.text = interest.title
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textField = textField as! AutocompleteField
        textField.text = textField.suggestion
        keyboardReturnTapped?()
        return false
    }
    
    //MARK: - Init Subviews
    lazy var interestTitleTextField: AutocompleteField = {
        let textField = AutocompleteField(frame: .zero, suggestions: [])
        textField.accessibilityLabel = "interest-textfield"
        textField.placeholder = "Reading & Writing..."
        textField.autocorrectionType = .no
        textField.font = UIFont(name: Theme.nunitoSansRegular, size: 14)
        textField.borderStyle = .none
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.backgroundColor = .apBackground
        textField.textColor = .apTintColor
        textField.tintColor = .apTintColor
        
        textField.clearButtonMode = .never
        textField.contentVerticalAlignment = .center
        textField.returnKeyType = .continue
        textField.keyboardType = .alphabet
        
        if let image = UIImage(systemName: "books.vertical.fill")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal) {
            textField.setLeftView(image: image)
            textField.leftViewPadding = 30
        }
        
        textField.autocapitalizationType = .words
        textField.suggestions = interestsSuggestions
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                    
        backgroundColor = .apBackground
        selectionStyle = .none
        
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
                
        accessibilityLabel = "interest-Cell"
            
        contentView.addSubview(interestTitleTextField)
                
        NSLayoutConstraint.activate([
            interestTitleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            interestTitleTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            interestTitleTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
