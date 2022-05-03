//
//  EducationTableViewCell.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 20/1/2022.
//

import UIKit


class EducationTableViewCell: UITableViewCell {
    
    var editButtonapped: (()->())?
    var moveButtonapped: (()->())?
    
    static var cellId = "educationCell"
    
    var education: Education! {
        didSet{
            guard let education = education else { return }
            
            let degree = education.degree
            let schoolName = education.schoolName
            let city = education.city

            var rangeDate = ""
            if let startDate = education.startDate {
                rangeDate = "\(formatRSDate(date: startDate)) - \(education.endDate != nil ? formatRSDate(date: education.endDate) : "Present")"
            }
            
            //Job Title
            if let degree = degree {
                degreeTitleLabel.attributedText = NSAttributedString(string: degree, attributes: [
                    .font : UIFont(name: Theme.nunitoSansSemiBold, size: 15) as Any,
                    .foregroundColor: UIColor.apTintColor])
            }
            
            //Date Range
            graduationRangeDateLabel.attributedText = NSAttributedString(string: rangeDate, attributes: [
                .font : UIFont(name: Theme.nunitoSansSemiBold, size: 12) as Any,
                .foregroundColor: UIColor.apTintColor.withAlphaComponent(0.7)])
            
            //School-Name
            if let schoolName = schoolName {
                let attributedText = NSMutableAttributedString(string: schoolName, attributes: [
                    .font : UIFont(name: Theme.nunitoSansSemiBold, size: 12) as Any,
                    .foregroundColor: UIColor.apTintColor.withAlphaComponent(0.7)])
                
                if let city = city {
                    let attText = " - \(city)"
                    attributedText.append(NSAttributedString(string: attText, attributes: [
                        .font : UIFont(name: Theme.nunitoSansSemiBold, size: 12) as Any,
                        .foregroundColor: UIColor.apTintColor.withAlphaComponent(0.7)]))
                }
                schoolNameLabel.attributedText = attributedText
            }
        }
    }
    
    //MARK: - Init Subviews
    
    let degreeTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let schoolNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let graduationRangeDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let responsabilitiesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
    
    lazy var editWorkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Edit-Icon")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var moveWorkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "move-Icon")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(didTapMoveWork), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func didTapEdit(){
        editButtonapped?()
    }
    
    @objc func didTapMoveWork(){
        moveButtonapped?()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        //MARK: - Border
        globalView.layer.borderColor = UIColor.apMainSectionCellBorder.cgColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .apBackground
        selectionStyle = .none
        
        contentView.addSubview(globalView)
        
        globalView.addSubview(degreeTitleLabel)
        globalView.addSubview(schoolNameLabel)
        globalView.addSubview(graduationRangeDateLabel)
        globalView.addSubview(responsabilitiesLabel)

        globalView.addSubview(editWorkButton)
        globalView.addSubview(moveWorkButton)
                
        NSLayoutConstraint.activate([
            
            globalView.topAnchor.constraint(equalTo: contentView.topAnchor),
            globalView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            globalView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            globalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            degreeTitleLabel.topAnchor.constraint(equalTo: globalView.topAnchor, constant: 7),
            degreeTitleLabel.leadingAnchor.constraint(equalTo: globalView.leadingAnchor, constant: 7),
            degreeTitleLabel.widthAnchor.constraint(lessThanOrEqualTo: globalView.widthAnchor, multiplier: 0.6),
            degreeTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            graduationRangeDateLabel.topAnchor.constraint(equalTo: globalView.topAnchor, constant: 8),
            graduationRangeDateLabel.trailingAnchor.constraint(equalTo: globalView.trailingAnchor, constant: -8),
            
            schoolNameLabel.topAnchor.constraint(equalTo: degreeTitleLabel.bottomAnchor, constant: 2),
            schoolNameLabel.leadingAnchor.constraint(equalTo: degreeTitleLabel.leadingAnchor),
            schoolNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16),
            schoolNameLabel.widthAnchor.constraint(equalTo: globalView.widthAnchor, multiplier: 0.8),
            schoolNameLabel.bottomAnchor.constraint(equalTo: globalView.bottomAnchor, constant: -7),

            editWorkButton.topAnchor.constraint(equalTo: graduationRangeDateLabel.bottomAnchor, constant: 2),
            editWorkButton.trailingAnchor.constraint(equalTo: globalView.trailingAnchor, constant: -10),
            editWorkButton.heightAnchor.constraint(equalToConstant: 24),
            
            moveWorkButton.trailingAnchor.constraint(equalTo: editWorkButton.leadingAnchor, constant: -5),
            moveWorkButton.centerYAnchor.constraint(equalTo: editWorkButton.centerYAnchor),
            moveWorkButton.heightAnchor.constraint(equalToConstant: 24),
            moveWorkButton.bottomAnchor.constraint(equalTo: schoolNameLabel.bottomAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
