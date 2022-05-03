//
//  SkillsTableViewCell.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 21/1/2022.
//

import UIKit
import CoreData


class SkillsTableViewCell: UITableViewCell, UITextFieldDelegate {

    static var cellId = "skillCell"
    var keyboardReturnTapped: (()->())?    
    var objectId: NSManagedObjectID? = nil
    
    var skill: Skills? {
        didSet {
            guard let skill = skill else { return }

            skillTitleTextField.text = skill.title
            ratingStackView.starsRating = Int(skill.level)

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardReturnTapped?()
        return false
    }

    
    //MARK: - Init Subviews
    lazy var skillTitleTextField: customFormField = {
        let textField = customFormField(LCtitle: "Ex : e.g. CAP Manager", border: false)
        textField.accessibilityLabel = "skill-textfield"
        textField.clearButtonMode = .never
        textField.delegate = self
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
                
        accessibilityLabel = "Skill-Cell"
            
        contentView.addSubview(skillTitleTextField)
        contentView.addSubview(ratingStackView)
                
        NSLayoutConstraint.activate([
            skillTitleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            skillTitleTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            skillTitleTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            
            ratingStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            ratingStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
