//
//  MainSectionsTableViewCell.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 10/2/2022.
//

import UIKit
import CoreData



class MainSectionsTableViewCell: UITableViewCell {
    
    static var cellId = "educationCell"
    
    var sectionIn: MainSections? {
        didSet{
            
            guard let sectionIn = sectionIn else { return }
            
            let title = sectionIn.description
            let icon = sectionIn.infos.icon
            
            let _icon = NSTextAttachment()
            _icon.image = icon?.withRenderingMode(.alwaysOriginal).withTintColor(.apTintColor)
            
            if let image = _icon.image {
                _icon.bounds = CGRect(x: 0, y: -1, width: image.size.width-5, height: image.size.height-5)
            }
            
            let attachement = NSAttributedString(attachment: _icon)
            
            let attributedText = NSMutableAttributedString(string: "")
            attributedText.append(attachement)
            attributedText.append(NSAttributedString(string: " "))
            attributedText.append(NSAttributedString(string: title, attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 15) as Any, .foregroundColor : UIColor.apTintColor as Any]))
            
            sectionTitle.attributedText = attributedText
            
            //Slogan
            let slogan = sectionIn.infos.slogan
            
            let sloganAttributedText = NSAttributedString(string: "\(slogan)", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
            
            sloganLabel.attributedText = sloganAttributedText
        }
    }
    
    lazy var sectionTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sloganLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var globalView: UIView = {
        let cellView = UIView()
        cellView.accessibilityLabel = "globalView"
        cellView.layer.masksToBounds = true
        cellView.clipsToBounds = true
        cellView.layer.cornerRadius = 2
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor.apMainSectionCellBorder.cgColor
        cellView.translatesAutoresizingMaskIntoConstraints = false
        return cellView
    }()
    
    lazy var rightView: UIView = {
        let _view = UIView()
        _view.backgroundColor = .appleBlossom
        _view.isHidden = false
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        //MARK: - Update
        let rightSideimage = UIImage(named: "add-section-circle")?.withRenderingMode(.alwaysOriginal)
        let rightImageView = UIImageView(image: rightSideimage)
        rightImageView.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        accessoryView = rightImageView
        
        //MARK: - Border
        globalView.layer.borderColor = UIColor.apMainSectionCellBorder.cgColor
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let rightSideimage = UIImage(named: "add-section-circle")?.withRenderingMode(.alwaysOriginal)
        let rightImageView = UIImageView(image: rightSideimage)
        rightImageView.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        accessoryView = rightImageView
        
        backgroundColor = .apBackground
        selectionStyle = .none
        
        contentView.addSubview(globalView)
        globalView.addSubview(sectionTitle)
        globalView.addSubview(sloganLabel)
        
        globalView.addSubview(rightView)
        
        let slConstraint = globalView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -4)
        slConstraint.priority = UILayoutPriority(250)
        
        NSLayoutConstraint.activate([
            
            globalView.topAnchor.constraint(equalTo: contentView.topAnchor),
            globalView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            globalView.trailingAnchor.constraint(equalTo: trailingAnchor),
            globalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            slConstraint,
            
            sectionTitle.topAnchor.constraint(equalTo: globalView.topAnchor, constant: 7),
            sectionTitle.leadingAnchor.constraint(equalTo: globalView.leadingAnchor, constant: 7),
            
            sloganLabel.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 0),
            sloganLabel.leadingAnchor.constraint(equalTo: globalView.leadingAnchor, constant: 7),
            sloganLabel.widthAnchor.constraint(lessThanOrEqualTo: globalView.widthAnchor, multiplier: 0.8),
            sloganLabel.bottomAnchor.constraint(equalTo: globalView.bottomAnchor, constant: -10),
            
            rightView.topAnchor.constraint(equalTo: globalView.topAnchor),
            rightView.trailingAnchor.constraint(equalTo: globalView.trailingAnchor),
            rightView.bottomAnchor.constraint(equalTo: globalView.bottomAnchor),
            rightView.widthAnchor.constraint(equalToConstant: 4),
            
        ])
        
        globalView.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
