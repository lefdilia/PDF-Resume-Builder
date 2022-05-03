//
//  SwipingScreensCell.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 4/11/2021.
//

import UIKit

class SwipingScreensCell: UICollectionViewCell {
    
    var screen: Onboarding? {
        didSet {
            guard let screen = screen else { return }
            //HeaderText
            let headerTextAttributedText = NSMutableAttributedString(string: screen.headerText, attributes: [
                .font : UIFont(name: Theme.nunitoSansSemiBold, size: 22) as Any,
                .foregroundColor : UIColor.white])
            headerText.attributedText = headerTextAttributedText
            //BodyText
            let bodyTextAttributedText = NSMutableAttributedString(string: screen.bodyText, attributes: [
                .font : UIFont(name: Theme.nunitoSansRegular, size: 19) as Any,
                .foregroundColor : UIColor.white])
            bodyText.attributedText = bodyTextAttributedText
            //screenImage
            screenImage.image = UIImage(named: screen.screenImage)
        }
    }
    
    let headerText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let screenImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let bodyText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let topImageContainerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .apSwipeBackground
        
        addSubview(topImageContainerView)
        topImageContainerView.addSubview(headerText)
        topImageContainerView.addSubview(screenImage)
        
        addSubview(topImageContainerView)
        addSubview(bodyText)

        NSLayoutConstraint.activate([
            topImageContainerView.topAnchor.constraint(equalTo: topAnchor),
            topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            headerText.bottomAnchor.constraint(equalTo: screenImage.topAnchor, constant: 0),
            headerText.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
        
            screenImage.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
            screenImage.bottomAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: -5),
            screenImage.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.7),

            bodyText.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: 10),
            bodyText.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
            bodyText.widthAnchor.constraint(equalTo: topImageContainerView.widthAnchor, multiplier: 0.9)
            
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
