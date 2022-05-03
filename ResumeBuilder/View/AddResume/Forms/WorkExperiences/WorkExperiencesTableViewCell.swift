//
//  WorkExperiencesTableViewCell.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 11/1/2022.
//

import UIKit


class WorkExperiencesTableViewCell: UITableViewCell {
    
    var editButtonapped: (()->())?
    var moveButtonapped: (()->())?

    static var cellId = "workExperienceCell"
    
    let pattern = "^\\*{2}([A-Za-z0-9 ]+)\\*{2}" // **Projects**
    let _pattern = "\\((\\s+)?([A-Za-zÀ-ÖØ-öø-ÿ ]+)(\\s+)?\\)" // (Published on github)
    
    var workExperience: WorkExperiences! {
        didSet{
            guard let workExperience = workExperience else { return }
            
            let jobTitle = workExperience.jobTitle
            let company = workExperience.company

            var rangeDate = ""
            if let startDate = workExperience.startDate {
                rangeDate = "\(formatRSDate(date: startDate)) - \(workExperience.endDate != nil ? formatRSDate(date: workExperience.endDate) : "Present")"
            }
            
            //Job Title
            if let jobTitle = jobTitle {
                jobTitleLabel.attributedText = NSAttributedString(string: jobTitle, attributes: [
                    .font : UIFont(name: Theme.nunitoSansSemiBold, size: 15) as Any,
                    .foregroundColor: UIColor.apTintColor])
            }
            
            //Date Range
            jobRangeDateLabel.attributedText = NSAttributedString(string: rangeDate, attributes: [
                    .font : UIFont(name: Theme.nunitoSansSemiBold, size: 12) as Any,
                    .foregroundColor: UIColor.apTintColor.withAlphaComponent(0.7)])
            
            
            //Company
            if let company = company {
                companyNameLabel.attributedText = NSAttributedString(string: company, attributes: [
                    .font : UIFont(name: Theme.nunitoSansSemiBold, size: 12) as Any,
                    .foregroundColor: UIColor.apTintColor.withAlphaComponent(0.7)])
            }
            
            //jobTitleLabel
            if let responsibilities = workExperience.responsibilities {
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 1.3
                paragraphStyle.lineSpacing = 1.0
                
                let globalAttributedString = NSMutableAttributedString()
                
                for (index, role) in responsibilities.enumerated() {
                    
                    var attributedString: NSAttributedString
                    
                    if role.matches(pattern) {
                        let _role = role.replacingOccurrences(of: pattern, with: "$1", options: .regularExpression, range: nil)

                        attributedString = NSMutableAttributedString(string: "\(_role.capitalized)\n", attributes: [
                            .font : UIFont(name: Theme.nunitoSansBold, size: 12) as Any,
                            .foregroundColor: UIColor.apTintColor,
                            .paragraphStyle: paragraphStyle
                        ])
                        
                    }else{
                        let spacing = index < responsibilities.count ? "\n" : ""
                        
                        attributedString = NSMutableAttributedString(string: "\(role)\(spacing)", attributes: [
                            .font : UIFont(name: Theme.nunitoSansSemiBold, size: 12) as Any,
                            .foregroundColor: UIColor.apTintColor.withAlphaComponent(0.7),
                            .paragraphStyle: paragraphStyle
                        ])
                    }
                    
                    globalAttributedString.append(attributedString)
                }

                let ranges = findSubStringRanges(string: globalAttributedString.string, pattern: _pattern)

                for range in ranges {
                    globalAttributedString.addAttribute(.font, value: UIFont(name: Theme.nunitoSansBold, size: 12) as Any, range: range)
                    globalAttributedString.addAttribute(.foregroundColor, value: UIColor.apSocialLinksButton, range: range)
                }
                                                                
                responsabilitiesLabel.attributedText = globalAttributedString
            }
        }
    }
    
    //MARK: - Init Subviews

    let jobTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobRangeDateLabel: UILabel = {
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

        globalView.addSubview(jobTitleLabel)
        globalView.addSubview(companyNameLabel)
        globalView.addSubview(jobRangeDateLabel)
        globalView.addSubview(responsabilitiesLabel)
        
        globalView.addSubview(editWorkButton)
        globalView.addSubview(moveWorkButton)
        
        NSLayoutConstraint.activate([
            
            globalView.topAnchor.constraint(equalTo: contentView.topAnchor),
            globalView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            globalView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            globalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            jobTitleLabel.topAnchor.constraint(equalTo: globalView.topAnchor, constant: 7),
            jobTitleLabel.leadingAnchor.constraint(equalTo: globalView.leadingAnchor, constant: 7),
            jobTitleLabel.widthAnchor.constraint(lessThanOrEqualTo: globalView.widthAnchor, multiplier: 0.6),
            jobTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            jobRangeDateLabel.topAnchor.constraint(equalTo: globalView.topAnchor, constant: 8),
            jobRangeDateLabel.trailingAnchor.constraint(equalTo: globalView.trailingAnchor, constant: -8),
            
            companyNameLabel.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 2),
            companyNameLabel.leadingAnchor.constraint(equalTo: jobTitleLabel.leadingAnchor),
            companyNameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            responsabilitiesLabel.topAnchor.constraint(equalTo: companyNameLabel.bottomAnchor, constant: 8),
            responsabilitiesLabel.leadingAnchor.constraint(equalTo: companyNameLabel.leadingAnchor),
            responsabilitiesLabel.trailingAnchor.constraint(equalTo: jobRangeDateLabel.trailingAnchor),
            responsabilitiesLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            responsabilitiesLabel.bottomAnchor.constraint(equalTo: globalView.bottomAnchor, constant: -5),

            editWorkButton.topAnchor.constraint(equalTo: jobRangeDateLabel.bottomAnchor, constant: 2),
            editWorkButton.trailingAnchor.constraint(equalTo: globalView.trailingAnchor, constant: -10),
            editWorkButton.heightAnchor.constraint(equalToConstant: 24),
            
            moveWorkButton.trailingAnchor.constraint(equalTo: editWorkButton.leadingAnchor, constant: -5),
            moveWorkButton.centerYAnchor.constraint(equalTo: editWorkButton.centerYAnchor),
            moveWorkButton.heightAnchor.constraint(equalToConstant: 24),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
