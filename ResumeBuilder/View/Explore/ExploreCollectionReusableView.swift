//
//  ExploreCollectionReusableView.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 9/3/2022.
//

import UIKit

class ExploreCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "footerCollectionViewVertically"
    
    var buildResume: (()->())?

    lazy var addResume: AddNewSection = {
        let _view = AddNewSection(title: "Build a Convincing Resume", color: .apBorder, lineWidth: 1.4, icon: .customLight(height: 40, width: 40))
        _view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddResumeView)))
        _view.centerText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddResume)))
        _view.addButton.addTarget(self, action: #selector(didTapAddResume), for: .touchUpInside)
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
    }()

    @objc func didTapAddResumeView(){
        buildResume?()
    }
    
    @objc func didTapAddResume(){
        buildResume?()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(addResume)
        backgroundColor = .apBackground
                
        NSLayoutConstraint.activate([
            addResume.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            addResume.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            addResume.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            addResume.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])

    }
    
}
