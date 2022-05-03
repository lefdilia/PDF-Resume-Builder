//
//  SwitchSettingsCell.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 10/3/2022.
//

import UIKit



class SwitchSettingsCell: UITableViewCell {
    
    static var cellId = "switchSettingsCell"
    
    var _setting: SwitchSettings? {
        didSet{
            guard let _setting = _setting else { return }
            optionTitle.text = _setting.title
            optionSlogan.text = !_setting.slogan!.isEmpty ? "\(_setting.slogan!)" : ""
            optionValues.text = _setting._values
        }
    }
    
    let optionTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        let attributedText = NSMutableAttributedString(string: "--", attributes: [
                                                        .font: UIFont.systemFont(ofSize: 14, weight: .regular) as Any,
                                                        .foregroundColor: UIColor.apSettingsTintColor as Any])
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let optionSlogan: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        let attributedText = NSMutableAttributedString(string: "--", attributes: [
                                                        .font: UIFont.systemFont(ofSize: 13, weight: .light) as Any,
                                                        .foregroundColor: UIColor.apSettingsTintColor as Any])
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stacktitle: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [optionTitle, optionSlogan])
        stack.axis = .vertical
        stack.setCustomSpacing(5, after: optionTitle)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let optionValues: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        let attributedText = NSMutableAttributedString(string: " ", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .light) as Any, .foregroundColor: UIColor.apSettingsTintColor as Any])
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        contentView.addSubview(stacktitle)
        contentView.addSubview(optionValues)
        
        backgroundColor = .apBackground
        
        separatorInset = .zero
        layoutMargins = .zero

        NSLayoutConstraint.activate([
            stacktitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            stacktitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            optionValues.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionValues.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
