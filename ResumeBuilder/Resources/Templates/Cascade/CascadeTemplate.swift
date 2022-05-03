//
//  CascadeTemplate2.swift
//  TemplatesTest
//
//  Created by Lefdili Alaoui Ayoub on 18/12/2021.
//

import UIKit
import PDFKit

class CascadeTemplate: UIView {
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    //MARK: - User Options
    var resumeData: ResumeData!
    var leftSectionsBlock: [SectionBlock] = []
    var rightStacksBlock: [StackBlock] = []
    var imageType: ImageType = .square
    
    //Try to Add a way to extend Font with Ratio 12:14
    var selectedFont: Fonts!
    
    //MARK: - Colors Options
    var leftSideBackgroundColor: UIColor?
    var leftSideTextColor: UIColor?
    var leftSectionTextColor: UIColor?
    var lineSeparatorColor: UIColor?
    var sectionBackgroundColor: UIColor?
    var progressdColor: UIColor?
    var progressBackgroundColor: UIColor?
    var rightSectionTextColor: UIColor?
    var rightBlockTextColor: UIColor?
    
    //MARK: - PDF Constraints
    var contentViewWidthAnchor: NSLayoutConstraint!
    var leftSideWidthAnchorMultiplier: NSLayoutConstraint!
    var leftSideWidthAnchorConstant: NSLayoutConstraint!
    var rightSideWidthAnchorConstant: NSLayoutConstraint!

    var resumeSize: ResumeSize = .USLetter
    var resumeHeightSize: NSLayoutConstraint!
        
    var leftSideConstraint: NSLayoutConstraint!
    var righSideConstraint: NSLayoutConstraint!
    
    init(size: ResumeSize, imageType: ImageType, font: Fonts, colorOptions: TemplatesColors, data resumeData: ResumeData?) {
        super.init(frame: .zero)
        
        guard let resumeData = resumeData else { return }
        
        self.resumeData = resumeData
        self.leftSectionsBlock = resumeData.sections.sorted(by: { $0.index < $1.index })
        self.rightStacksBlock = resumeData.stacks.sorted(by: { $0.index < $1.index })
        
        self.imageType = imageType
        self.selectedFont = font
        
        self.resumeSize = size
        
        let selectedColor = Theme.usedTemplate(with: .template(.Cascadetpl, colorOptions))

        self.leftSideBackgroundColor = selectedColor["leftSideBackgroundColor"] ?? .clear
        self.leftSideTextColor = selectedColor["leftSideTextColor"] ?? .white
        self.leftSectionTextColor = selectedColor["leftSectionTextColor"] ?? .white
        self.lineSeparatorColor = selectedColor["lineSeparatorColor"] ?? .black
        self.sectionBackgroundColor = selectedColor["sectionBackgroundColor"] ?? .blue
        self.progressdColor = selectedColor["progressdColor"] ?? .white
        self.progressBackgroundColor = selectedColor["progressBackgroundColor"] ?? .gray
        self.rightSectionTextColor = selectedColor["rightSectionTextColor"] ?? .black
        self.rightBlockTextColor = selectedColor["rightBlockTextColor"] ?? .black
        
        //MARK: - Setup Constraints
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(leftSide)
        contentView.addSubview(rightSide)
        
        leftSide.addSubview(leftStack)
        
        rightSide.addSubview(rightStack)
        
        let contentViewHeightConstraintPriority = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentViewHeightConstraintPriority.priority = UILayoutPriority(250)
    
        //🚨 Start-Important
        leftSideConstraint = leftSide.heightAnchor.constraint(greaterThanOrEqualTo: leftStack.heightAnchor, constant: 30)
        righSideConstraint = rightSide.heightAnchor.constraint(greaterThanOrEqualTo: rightStack.heightAnchor, constant: 30)
        //🚨 End-Important
        
        contentViewWidthAnchor = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        contentViewWidthAnchor.isActive = true
        
        leftSideWidthAnchorMultiplier = leftSide.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.330)
        leftSideWidthAnchorMultiplier.isActive = true
        
        let _resumesize = self.resumeSize.size
        
        let _leftSideWidth = ceil(_resumesize.width / 4.25)
        let _rightSideWidth =  ceil(_resumesize.width - _leftSideWidth)

        
        //TestOnly
        resumeHeightSize = scrollView.heightAnchor.constraint(equalToConstant: _resumesize.height)
        resumeHeightSize.isActive = false
        //TestOnly
        
        leftSideWidthAnchorConstant = leftSide.widthAnchor.constraint(equalToConstant: _leftSideWidth)
        leftSideWidthAnchorConstant.isActive = false
        
        rightSideWidthAnchorConstant = rightSide.widthAnchor.constraint(equalToConstant: _rightSideWidth)
        rightSideWidthAnchorConstant.isActive = false
       

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            //MARK: - contentView (Constraints)
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentViewHeightConstraintPriority,

            //MARK: - leftSide (Constraints)
            leftSide.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftSide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftSide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            leftSideConstraint,
            
            //MARK: - rightSide (Constraints)
            rightSide.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightSide.leadingAnchor.constraint(equalTo: leftSide.trailingAnchor, constant: 0),
            rightSide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            rightSide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            righSideConstraint,
            
            //MARK: - rightStack (Constraints)
            rightStack.topAnchor.constraint(equalTo: rightSide.topAnchor, constant: 5),
            rightStack.leadingAnchor.constraint(equalTo: rightSide.leadingAnchor),
            rightStack.trailingAnchor.constraint(equalTo: rightSide.trailingAnchor),
            rightStack.widthAnchor.constraint(equalTo: rightSide.widthAnchor),
 
            //MARK: - LeftStack (Constraints)
            leftStack.topAnchor.constraint(equalTo: leftSide.topAnchor),
            leftStack.leadingAnchor.constraint(equalTo: leftSide.leadingAnchor),
            leftStack.trailingAnchor.constraint(equalTo: leftSide.trailingAnchor),
            leftStack.widthAnchor.constraint(equalTo: leftSide.widthAnchor),
            
        ])

    }
    
    override func layoutSubviews() {

        if headingStack.frame.size.height > 0.0 {
           let headingStackHeightConstraintPriority = headingStack.heightAnchor.constraint(equalToConstant:  headingStack.frame.size.height)
            headingStackHeightConstraintPriority.isActive = true
            
            leftSideConstraint.constant = headingStack.frame.size.height + 30
            layoutIfNeeded()
        }
    }
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var leftSide: UIView = {
        let _view = UIView()
        _view.backgroundColor = leftSideBackgroundColor
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
    }()
    
    lazy var rightSide: UIView = {
        let _view = UIView()
        _view.backgroundColor = .white
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
    }()
    
    lazy var leftStack = leftContainerBlock(sections: leftSectionsBlock)
    
    //MARK: - Summary
    lazy var Summary: UILabel = {
        let label = UILabel()
        let summary = resumeData.summary ?? ""
        
        label.attributedText = NSAttributedString(string: summary, attributes: [.foregroundColor: self.rightBlockTextColor as Any, .font: UsedFonts.Summary(font: selectedFont).uiFont as Any])

        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setLineSpacing(lineSpacing: 4.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Functions (Right Side)
    
    lazy var rightStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
                
        stack.addArrangedSubview(Summary)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        
        for stackBlock in rightStacksBlock {
            
            var titleFont:TitleFontOtions = .default(font: selectedFont)
            
            if (stackBlock.section == BuiltInSection.workExperiences || stackBlock.section == BuiltInSection.education) {
                titleFont = .custom(font: selectedFont)
            }else{
                titleFont = .default(font: selectedFont, size: 11)
            }
            
            let Block = self.rightContainerBlock(stackBlock: stackBlock, font: titleFont)
            stack.addArrangedSubview(Block)
        }
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func buildRightSection(title: String) -> UIStackView {
        
        lazy var section: UIStackView = {
            let stack = UIStackView()
            
            let label = UILabel()
            label.attributedText = NSAttributedString(string: title.capitalized,
                                                      attributes: [
                                                        .foregroundColor: self.rightSectionTextColor as Any,
                                                        .font: UsedFonts.RightSectionLabel(font: selectedFont).uiFont as Any
                                                      ])
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let spColor = self.lineSeparatorColor ?? .gray
            
            stack.addArrangedSubview(createSeparator(color: spColor))
            stack.addArrangedSubview(label)
            stack.addArrangedSubview(createSeparator(color: spColor))
            
            stack.spacing = 5
            stack.axis = .vertical
            
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            stack.isLayoutMarginsRelativeArrangement = true
            stack.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 1)
            
            return stack
        }()
        
        return section
    }
    
    private func rightBlocks(title: String, location: String?, rangeDate: ((start: String, finish: String?))?,  roles: [String] = [], font: TitleFontOtions?, section: BuiltInSection? = nil ) -> UIView {
        
        // #. job Range Date
        let jobRangeDate: UILabel = {
            let label = UILabel()
            var _date = ""
            
            if let rangeDate = rangeDate {
                _date = "\(rangeDate.start) \(rangeDate.finish ?? "")" //"2006-12 -\n Present"
            }
            
            //Build date Ranges [From - To(/!\Current)] -> 2006-12 -\n Present
            label.attributedText = NSAttributedString(string: _date,
                                                      attributes: [
                                                        .foregroundColor: self.rightBlockTextColor as Any,
                                                        .font: UsedFonts.rangeDate(font: selectedFont).uiFont as Any ])
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        
        // #. job Title
        let jobTitle: UILabel = {
            let label = UILabel()
            label.attributedText = NSAttributedString(string: title, attributes: [
                .foregroundColor: self.rightBlockTextColor as Any,
                .font: font?.options as Any,
                .kern: 0.1
            ])
            
            label.numberOfLines = 0
            label.textAlignment = .left
            label.lineBreakMode = .byWordWrapping
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // #. job Location
        let jobLocation: UILabel = {
            let label = UILabel()
            label.attributedText = NSAttributedString(string: location ?? "",
                                                      attributes: [
                                                        .foregroundColor: self.rightBlockTextColor as Any,
                                                        .font: UsedFonts.jobLocation(font: selectedFont).uiFont as Any
                                                      ])
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // #. List of Roles
        lazy var jobRoles: UIStackView = {
            let stack = UIStackView()

            let pattern = "^\\*{2}([A-Za-z0-9 ]+)\\*{2}" // **Projects**
            let _pattern = "\\((\\s+)?([A-Za-zÀ-ÖØ-öø-ÿ ]+)(\\s+)?\\)" // (Published on github)

            let projectsIndex = roles.enumerated().filter({ $0.element.matches(pattern) }).map({ $0.offset }).first
            
            for (index, role) in roles.enumerated() {
                
                let infoLabel = UILabel()
                let attributedText = NSMutableAttributedString()

                let customSpace = (projectsIndex != nil && projectsIndex! > index) ? "\r" : ""
                var roleAttribute = NSMutableAttributedString(string: "\(customSpace) \(role)", attributes: [
                                                          .font: UsedFonts.jobRoles(font: selectedFont).uiFont as Any,
                                                          .foregroundColor: self.rightBlockTextColor as Any
                                                       ])
                                
                let dotColor = self.leftSideBackgroundColor ?? .black
                let dot = NSTextAttachment()
                dot.image = UIImage(named: "dot-2")?.withTintColor(dotColor)
                dot.bounds = CGRect(x: 0, y: 0, width: 3, height: 3)
            
                
                //Parse Projects Title
                if section == .workExperiences {
              
                    if role.matches(pattern) {
                        let _role = role.replacingOccurrences(of: pattern, with: "$1", options: .regularExpression, range: nil)
                        
                        roleAttribute = NSMutableAttributedString(string: "\r\(_role.capitalized)", attributes: [
                            .font: UsedFonts.jobRolesTitle(font: selectedFont).uiFont as Any,
                            .foregroundColor: self.rightBlockTextColor as Any
                        ])
                        
                        dot.image = nil
                        dot.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
                    }
                    
                    if let projectsIndex = projectsIndex, projectsIndex > index {
                        dot.image = nil
                        dot.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
                    }

                }

                let attchement = NSAttributedString(attachment: dot)
                
                //Edited
                if section != .education && dot.image != nil {
                    attributedText.append(attchement)
                }
                
                attributedText.append(roleAttribute)
                
                let ranges = findSubStringRanges(string: attributedText.string, pattern: _pattern)

                for range in ranges {
                    attributedText.addAttribute(.font, value: UsedFonts.jobRolesBrackets(font: selectedFont).uiFont as Any, range: range)
                }
                    
                infoLabel.attributedText = attributedText
                
                infoLabel.translatesAutoresizingMaskIntoConstraints = false
                
                infoLabel.lineBreakMode = .byWordWrapping
                infoLabel.numberOfLines = 0
                                
                stack.addArrangedSubview(infoLabel)
            }
            
            stack.axis = .vertical
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        lazy var jobGroupedView: UIView = {
            let jobview = UIView()
            jobview.addSubview(jobRangeDate)
            jobview.addSubview(jobTitle)
            jobview.addSubview(jobLocation)
            jobview.addSubview(jobRoles)
            
            //MARK: - Fix Aligmenets for different Sections /!\
            
            var jobRolesConstraint: NSLayoutConstraint = jobRoles.leadingAnchor.constraint(equalTo: jobTitle.leadingAnchor, constant: 0)
            var jobTitleConstraint: NSLayoutConstraint = jobTitle.leadingAnchor.constraint(equalTo: jobRangeDate.trailingAnchor, constant: 10)
            var jobLocationConstraint: NSLayoutConstraint = jobLocation.leadingAnchor.constraint(equalTo: jobTitle.leadingAnchor)

            // Accomplishments
            if section == .accomplishments {
                jobRolesConstraint = jobRoles.leadingAnchor.constraint(equalTo: jobview.leadingAnchor, constant: 5)
            }
            
            // Additional-Information
            if section == .additionalInformation {
                jobTitleConstraint = jobTitle.leadingAnchor.constraint(equalTo: jobview.leadingAnchor, constant: 5)
            }
            
            // Interests
            if section == .interests {
                jobLocationConstraint =  jobLocation.leadingAnchor.constraint(equalTo: jobview.leadingAnchor, constant: 5)
            }
            
            if case BuiltInSection.customSection = section! {
                jobTitleConstraint = jobTitle.leadingAnchor.constraint(equalTo: jobview.leadingAnchor, constant: 5)
            }
            

            NSLayoutConstraint.activate([
                
                jobRangeDate.topAnchor.constraint(equalTo: jobview.topAnchor, constant: 0),
                jobRangeDate.leadingAnchor.constraint(equalTo: jobview.leadingAnchor, constant: 5),
                jobRangeDate.widthAnchor.constraint(equalToConstant: 50),
                
                jobTitle.topAnchor.constraint(equalTo: jobview.topAnchor, constant: 0),
                jobTitleConstraint,
                jobTitle.trailingAnchor.constraint(equalTo: jobview.trailingAnchor, constant: -2),
                
                jobLocation.topAnchor.constraint(equalTo: jobTitle.bottomAnchor, constant: 1),
                jobLocationConstraint,
                jobLocation.trailingAnchor.constraint(equalTo: jobview.trailingAnchor, constant: -1),
                
                jobRoles.topAnchor.constraint(equalTo: jobLocation.bottomAnchor, constant: 0),
                jobRolesConstraint,
                jobRoles.trailingAnchor.constraint(equalTo: jobview.trailingAnchor, constant: -3),
                jobRoles.bottomAnchor.constraint(equalTo: jobview.bottomAnchor, constant: -5)
            ])
            
            jobview.translatesAutoresizingMaskIntoConstraints = false
            return jobview
        }()
        
        return jobGroupedView
    }
    
    private func rightContainerBlock(stackBlock: StackBlock, font: TitleFontOtions? ) -> UIStackView {
        
        let _section: UIStackView = buildRightSection(title: stackBlock.section.description)
        
        lazy var blockViewStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            
            stack.distribution = .equalSpacing // Fix Error UIStackView Height
            
            stack.addArrangedSubview(_section)
            
            for (_, block) in stackBlock.infos.enumerated() {
                let View = self.rightBlocks(title: block.title, location: block.location, rangeDate: block.rangeDate, roles: block.roles, font: font, section: stackBlock.section)
                stack.addArrangedSubview(View)
                
                if stackBlock.section != .accomplishments {
                    stack.spacing = 10
                }else{
                    stack.spacing = 4
                }
            }
            
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
                        
        return blockViewStack
    }
    
    //MARK: - Heading View
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()

        if let image = self.resumeData.image {
            imageView.image = image
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            
            imageView.layer.borderWidth = 1.3
            imageView.contentMode = .scaleAspectFill
            
            var height: CGFloat = 0.0
            var width: CGFloat = 0.0
            
            if self.imageType == .oval {
                height = 70
                width = height
                imageView.layer.cornerRadius = width / 2
            }
            
            if self.imageType == .square {
                width = 55
                height = 70
                imageView.layer.cornerRadius = 4
            }
            
            imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
            
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var fullName: UILabel = {
        let label = UILabel()
                
        let firstName = resumeData.firstName
        let lastName = resumeData.lastName
        let fullName = "\(firstName ?? "") \(lastName ?? "")".capitalized
        
        let attributedText = NSMutableAttributedString(string: fullName,
                                                       attributes: [
                                                        .foregroundColor: self.leftSideTextColor ?? .black,
                                                        .font: UsedFonts.fullname(font: selectedFont).uiFont as Any
                                                       ])
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    lazy var profession: UILabel = {
        let label = UILabel()
        
        let profession = resumeData.profession ?? ""
        
        let attributedText = NSMutableAttributedString(string: profession,
                                                       attributes: [
                                                        .foregroundColor: self.leftSideTextColor ?? .black,
                                                        .font: UsedFonts.profession(font: selectedFont).uiFont as Any
                                                       ])
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        return label
    }()
    
    
    lazy var headingStack: UIView = {
        let _view = UIView()
        _view.addSubview(profileImage)
        _view.addSubview(fullName)
        _view.addSubview(profession)
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: _view.topAnchor, constant: 8),
            profileImage.centerXAnchor.constraint(equalTo: _view.centerXAnchor),
            
            fullName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 5),
            fullName.centerXAnchor.constraint(equalTo: _view.centerXAnchor),
            fullName.widthAnchor.constraint(equalTo: _view.widthAnchor, constant: -5),

            profession.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 2),
            profession.centerXAnchor.constraint(equalTo: _view.centerXAnchor),
            profession.widthAnchor.constraint(equalTo: _view.widthAnchor, constant: -5),

            profession.bottomAnchor.constraint(equalTo: _view.bottomAnchor, constant: 5),
        ])
        
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
    }()
    
    
    
    
    //MARK: - Left Section
    
    private func buildLeftSection(title: String) -> UIView {
        let section = UIView()
        section.backgroundColor = self.sectionBackgroundColor
        section.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.attributedText = NSAttributedString(string: title.capitalized,
                                                  attributes: [.foregroundColor: self.leftSectionTextColor as Any,
                                                               .font: UsedFonts.leftSectionLabel(font: selectedFont).uiFont as Any
                                                              ])
        label.adjustsFontSizeToFitWidth = true
        
        section.addSubview(label)

        label.centerYAnchor.constraint(equalTo: section.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 6).isActive = true
        
        label.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -3).isActive = true
        
        section.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return section
        
    }
    
    
    private func leftBlocks(sectionBlock: SectionBlock) -> UIView? {
        
        lazy var section: UIView = self.buildLeftSection(title: sectionBlock.section.description)
        
        let infos = sectionBlock.infos
        
        let checkInfos = infos.filter({ $0.value != nil })
        
        guard checkInfos.count > 0 else {
            return nil
        }
        
        lazy var sectionStackView: UIStackView = { [weak self] in
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.spacing = 5
            
                if sectionBlock.section == BuiltInSection.personalInfo {
                    
                    for (_key, _value) in Array(infos).sorted(by: {$0.0 > $1.0}) where _value != nil {
                        
                    let _info = _key.capitalized
                    
                    let infoLabel = UILabel()
                    infoLabel.translatesAutoresizingMaskIntoConstraints = false
                    infoLabel.lineBreakMode = .byWordWrapping
                    infoLabel.numberOfLines = 0
                    var attributedText = NSMutableAttributedString(string: "")
                    
                    if !_info.isEmpty {
                        attributedText = NSMutableAttributedString(string: "\(_info)\n", attributes: [.font : UsedFonts.userInfosKeyLabel(font: selectedFont).uiFont as Any,.foregroundColor: self?.leftSideTextColor as Any])
                    }
                    
                    attributedText.append(NSAttributedString(string: "\(_value ?? "--")",attributes: [.font : UsedFonts.userInfosValueLabel(font: selectedFont).uiFont as Any,.foregroundColor: self?.leftSideTextColor as Any]))
                    
                    infoLabel.attributedText = attributedText
                    
                    infoLabel.setLineSpacing(lineSpacing: 0) // space Key & Value
                    stack.addArrangedSubview(infoLabel)
                    stack.setCustomSpacing(8, after: infoLabel) // Space between Value & key+1
                    
                    }
                
                } else {
                    
                    for (_key, _value) in Array(infos).sorted(by: {$0.1 as! Int > $1.1 as! Int}) where _value != nil {
                        
                        let _info = _key.capitalized
                        
                        let infoLabel = UILabel()
                        infoLabel.translatesAutoresizingMaskIntoConstraints = false
                        infoLabel.lineBreakMode = .byWordWrapping
                        infoLabel.numberOfLines = 0
                        
                        let intLevel = _value as! Int
                        let attributedText = NSMutableAttributedString(string: "\(_info)",attributes: [.font :UsedFonts.leftBlockInfoLabel(font:selectedFont).uiFont as Any, .foregroundColor: self?.leftSideTextColor as Any ])
                        
                        infoLabel.attributedText = attributedText
                        let level = PlainHorizontalProgressBar(level: intLevel,color: self?.progressdColor ?? .gray)
                        
                        level.heightAnchor.constraint(equalToConstant: 4).isActive = true
                        
                        stack.addArrangedSubview(infoLabel)
                        stack.addArrangedSubview(level)
                        
                        if sectionBlock.section == BuiltInSection.languages {
                            let langugeScale = language(rawValue: intLevel)?.level ?? ""
                            let scaleLabel: UILabel = {
                                let label = UILabel()
                                let attributedText = NSMutableAttributedString(string: langugeScale,attributes: [.font : UsedFonts.leftBlockLangugeScaleLabel(font: selectedFont).uiFont as Any,.foregroundColor: self?.leftSideTextColor as Any])
                                label.attributedText = attributedText
                                label.translatesAutoresizingMaskIntoConstraints = false
                                return label
                            }()
                            
                            stack.addSubview(scaleLabel)
                            scaleLabel.topAnchor.constraint(equalTo: level.bottomAnchor, constant: 4).isActive = true
                            scaleLabel.trailingAnchor.constraint(equalTo: level.trailingAnchor, constant: 0).isActive = true
                            
                            stack.isLayoutMarginsRelativeArrangement = true
                            stack.layoutMargins.bottom = 10
                        }
                        stack.setCustomSpacing(15, after: level)
                    }
                }
            return stack
        }()
        
        
        lazy var groupedViews:UIView = {
            let groupedView = UIView()
            
            groupedView.addSubview(section)
            groupedView.addSubview(sectionStackView)
            
            NSLayoutConstraint.activate([
                section.topAnchor.constraint(equalTo: groupedView.topAnchor),
                section.leadingAnchor.constraint(equalTo: groupedView.leadingAnchor),
                section.trailingAnchor.constraint(equalTo: groupedView.trailingAnchor),
                section.heightAnchor.constraint(equalToConstant: 24),
                sectionStackView.topAnchor.constraint(equalTo: section.bottomAnchor, constant: 6),
                sectionStackView.leadingAnchor.constraint(equalTo: groupedView.leadingAnchor, constant: 5),
                sectionStackView.widthAnchor.constraint(equalTo: groupedView.widthAnchor, multiplier: 0.9),
                groupedView.bottomAnchor.constraint(equalTo: sectionStackView.bottomAnchor, constant: 4)
            ])
            
            groupedView.translatesAutoresizingMaskIntoConstraints = false
            return groupedView
        }()
        
        return groupedViews
    }
    
    
    private func leftContainerBlock(sections: [SectionBlock]) -> UIStackView {
        
        lazy var blockViewStack: UIStackView = { [weak self] in
            let stack = UIStackView(arrangedSubviews: [headingStack])
            stack.spacing = 10
            stack.axis = .vertical
            
            for section in sections {
                if let _NSSection = self?.leftBlocks(sectionBlock: section) {
                    stack.addArrangedSubview(_NSSection)
                }
            }
            
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        return blockViewStack
    }
    
    //MARK: - Code End
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - Extensions

extension CascadeTemplate {
    
   private func readyForBuild(_ status: Bool = true){
        if status == true {
            contentViewWidthAnchor.isActive = false
            resumeHeightSize.isActive = true
            leftSideWidthAnchorMultiplier.isActive = false
            leftSideWidthAnchorConstant.isActive = true
            rightSideWidthAnchorConstant.isActive = true
        }else if status == false {
            rightSideWidthAnchorConstant.isActive = false
            leftSideWidthAnchorConstant.isActive = false
            leftSideWidthAnchorMultiplier.isActive = true
            resumeHeightSize.isActive = false
            contentViewWidthAnchor.isActive = true
        }
        self.layoutIfNeeded()
    }
    
    func createResume(filename: String? = nil, completion: (URL?, Error?)->()) -> Void {

        let scrollView = self.scrollView
        
        self.readyForBuild(true) //Activate PDf Constraint
        CreateResume.shared.generate(scrollView: scrollView, filename: filename) { [weak self] (resume, error) in
            self?.readyForBuild(false) //Disable PDf Constraint
            guard let resume = resume, error == nil else {
                return completion(nil, error)
            }
            completion(resume, nil)
        }
    }
}

    
extension CascadeTemplate {
    
    enum TitleFontOtions {
        case custom(font: Fonts)
        case `default`(font: Fonts, size: CGFloat = 10)
        
        var options: UIFont? {
            switch self {
            case .custom(let _selectedFont):
                return UsedFonts.jobTitle(font: _selectedFont).uiFont
                
            case .default(let _selectedFont, let _size):
                return UsedFonts.defaultTitle(font: _selectedFont, size: _size).uiFont
            }
        }
    }
    
    enum UsedFonts {
        case fullname(font: Fonts)
        case profession(font: Fonts)
        case userInfosKeyLabel(font: Fonts)
        case userInfosValueLabel(font: Fonts)
        case leftSectionLabel(font: Fonts)
        case leftBlockInfoLabel(font: Fonts)
        case leftBlockLangugeScaleLabel(font: Fonts)
        case Summary(font: Fonts)
        case RightSectionLabel(font: Fonts)
        case rangeDate(font: Fonts)
        
        case jobTitle(font: Fonts)
        case defaultTitle(font: Theme.Formatting.Fonts, size: CGFloat)
        
        case jobLocation(font: Fonts)
        case jobRoles(font: Fonts)
        case jobRolesTitle(font: Fonts)
        case jobRolesBrackets(font: Fonts)

        var uiFont: UIFont? {
            switch self {
            case .fullname(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .bold)), size: 15*0.93)
                
            case .profession(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .regular)), size: 13*0.93)
                
            case .leftSectionLabel(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .bold)), size: 13*0.93)
                
            case .Summary(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .regular)), size: 11*0.93)
                
            case .jobTitle(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .bold)), size: 13*0.93)
                
            case .userInfosKeyLabel(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .bold)) , size: 11*0.93)
                
            case .userInfosValueLabel(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .regular)), size: 11*0.93)
                
            case .leftBlockInfoLabel(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .regular)), size: 11*0.93)
                
            case .RightSectionLabel(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .bold)), size: 13*0.93)
                
            case .jobLocation(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .italic)), size: 11*0.93)
                
            case .jobRoles(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .regular)), size: 11*0.93)
                
            case .jobRolesTitle(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .bold)), size: 12*0.93)
                
            case .jobRolesBrackets(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .bold)), size: 11*0.93)

            case .rangeDate(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .regular)), size: 11*0.93)
                
            case .leftBlockLangugeScaleLabel(let _selectedFont):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .regular)), size: 10*0.93)
                
            case .defaultTitle(let _selectedFont, let _size):
                return UIFont(name: Theme.usedFont(with: .font(_selectedFont, .regular)), size: _size*0.93)
            }
        }
    }
}
