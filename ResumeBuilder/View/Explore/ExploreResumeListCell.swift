//
//  ExploreResumeListCell.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 9/3/2022.
//

import UIKit

class ExploreResumeListCell: UICollectionViewCell {
    
    static var cellId = "CollectionViewCellId"
    
    var cardGradientColor = [UIColor]()
    var textInGradientColor: UIColor? = .white
    
    var userData: UserData? {
        didSet {
            
            guard let userData = userData else { return }
            
            if userData.type == .coverLetter  {
                cardGradientColor = [ .swissCoffee, .bizarre]
                textInGradientColor = .saltBox
            }else{
                cardGradientColor = [.apGradientFirst, .apGradientLast]
                textInGradientColor = .white
            }
            
            //Profile Picture
            if let imageData = userData.picture {
                profilePicture.image = UIImage(data: imageData)
            }
            
            //FullName
            let fullName = "\(userData.firstName) \(userData.lastName)"
            let nameLabelAttributedText = NSAttributedString(string: fullName, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 19) as Any])
            nameLabel.attributedText = nameLabelAttributedText
            
            //Profession
            var professionLabelAttributedText = NSMutableAttributedString(string: userData.profession, attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any])
            
            if userData.profession.isEmpty {
                professionLabelAttributedText = NSMutableAttributedString(string: "Profession" , attributes: [
                    .font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any])
                professionLabelAttributedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, professionLabelAttributedText.length))
            }
            
            professionLabel.attributedText = professionLabelAttributedText
            
            //Date creation
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd '-' HH:mm"
            
            if let dateCreated = userData.created {
                let dateCreation = dateFormatter.string(from: dateCreated)
                //dateCreationLabel
                let dateCreationLabelAttributedText = NSMutableAttributedString(string: "Created : ", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any ])
                let attributedDateCreation = NSAttributedString(string: dateCreation, attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any])
                dateCreationLabelAttributedText.append(attributedDateCreation)
                dateCreationLabel.attributedText = dateCreationLabelAttributedText
            }
            
            if let dateModified = userData.modified {
                let dateModification = dateFormatter.string(from: dateModified)
                //dateModificationLabel
                let dateModificationLabelAttributedText = NSMutableAttributedString(string: "Modified : ", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any ])
                let attributed = NSAttributedString(string: dateModification, attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any ])
                dateModificationLabelAttributedText.append(attributed)
                dateModificationLabel.attributedText = dateModificationLabelAttributedText
            }
            
        }
    }
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let professionLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateCreationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateModificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.image = image
            configuration.imagePlacement = .trailing
            button.configuration = configuration
        }else{
            button.setImage(image, for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 15)
        }
            
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var topButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.image = image
            configuration.imagePlacement = .trailing
            button.configuration = configuration
        }else{
            button.setImage(image, for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 15)
        }
        
        button.addTarget(self, action: #selector(didTapTopButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func didTapTopButton(){
        topButton.isEnabled = false
        shareClosure?()
    }

    override func layoutSubviews() {
        applyGradient(isVertical: false, colorArray: cardGradientColor)
        
        nameLabel.textColor = textInGradientColor
        professionLabel.textColor = textInGradientColor
        dateCreationLabel.textColor = textInGradientColor
        dateModificationLabel.textColor = textInGradientColor
        
        moreButton.tintColor = textInGradientColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 6
        layer.masksToBounds = true
        
        let editAction = self.editAction()
        let downloadAction = self.downloadAction()
        let previewAction = self.previewAction()
        let shareAction = self.shareAction()
        
        let deleteAction = self.deleteAction()
        
        
        if #available(iOS 14.0, *) {
            moreButton.menu = UIMenu(title: "", children: [editAction, shareAction, downloadAction, previewAction, deleteAction])
            moreButton.showsMenuAsPrimaryAction = true
        } else {
            let interaction = UIContextMenuInteraction(delegate: self)
            moreButton.addInteraction(interaction)
        }

        addSubview(profilePicture)
        addSubview(nameLabel)
        addSubview(professionLabel)
        addSubview(dateCreationLabel)
        addSubview(dateModificationLabel)
        addSubview(moreButton)
        addSubview(topButton)

        NSLayoutConstraint.activate([
            profilePicture.widthAnchor.constraint(equalToConstant: 50),
            profilePicture.heightAnchor.constraint(equalToConstant: 50),
            profilePicture.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            profilePicture.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            
            nameLabel.topAnchor.constraint(equalTo: profilePicture.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 8),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            
            professionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            professionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            professionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
            
            dateCreationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            dateCreationLabel.bottomAnchor.constraint(equalTo: dateModificationLabel.topAnchor, constant: 1),
            
            dateModificationLabel.leadingAnchor.constraint(equalTo: dateCreationLabel.leadingAnchor),
            dateModificationLabel.bottomAnchor.constraint(equalTo: moreButton.bottomAnchor, constant: -3),
            
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            moreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            
            topButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            topButton.topAnchor.constraint(equalTo: topAnchor, constant: 3)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var editClosure: (()->())?
    var downloadClosure: (()->())?
    var previewClosure: (()->())?
    var shareClosure: (()->())?
    var deleteClosure: (()->())?
    
}

extension ExploreResumeListCell: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            return UIMenu.init(title: "Menu", children: [self.editAction(), self.shareAction(), self.downloadAction(), self.previewAction(), self.deleteAction()])
         }
         return configuration
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        
        return UITargetedPreview(view: moreButton, parameters: parameters)
    }

}

extension ExploreResumeListCell: ContextMenu {
    
    func performEdit() {
        editClosure?()
    }
    
    func performDownload() {
        downloadClosure?()
    }
    
    func performPreview() {
        previewClosure?()
    }
    
    func performShare() {
        shareClosure?()
    }
    
    func performDelete() {
        deleteClosure?()
    }
    
}
