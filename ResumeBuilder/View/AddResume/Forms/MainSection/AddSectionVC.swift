//
//  AddSectionVC.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 7/2/2022.
//

import UIKit



class AddSectionVC: UIViewController, initialObjectDataSource{
    
    var passData: ((Initial?)->())?

    var arrayOfSections: [MainSections] = []
    
    var initialObject: Initial? {
        didSet{
            guard let initialObject = initialObject else { return }
            
            //Side Sections
            if let accomplishments = initialObject.accomplishments?.allObjects as? [Accomplishments], accomplishments.filter({ $0.status == true }).count == 0 {
                arrayOfSections.append(.accomplishments)
            }
            
            if let additionalInformation = initialObject.additionalInformation?.allObjects as? [AdditionalInformation], additionalInformation.filter({ $0.status == true }).count == 0 {
                arrayOfSections.append(.additionalInformation)
            }
            
            if let certifications = initialObject.certifications?.allObjects as? [Certifications], certifications.filter({ $0.status == true }).count == 0 {
                arrayOfSections.append(.certifications)
            }
            
            if let interests = initialObject.interests?.allObjects as? [Interests], interests.filter({ $0.status == true }).count == 0 {
                arrayOfSections.append(.interests)
            }
            
            if let softwares = initialObject.softwares?.allObjects as? [Softwares], softwares.filter({ $0.status == true }).count == 0 {
                arrayOfSections.append(.softwares)
            }
            
            for (index, section) in arrayOfSections.enumerated() {
                
                let sectionTitle = section.description
                
                let button = UIButton(type: .custom)
                
                if #available(iOS 15.0, *) {
                    
                    var config = UIButton.Configuration.plain()
                    config.imagePadding = 8
                    config.contentInsets.leading = 0
                    
                    var container = AttributeContainer()
                    container.font = UIFont(name: Theme.nunitoSansSemiBold, size: 14)
                    container.foregroundColor = .apTintColor
                    container.underlineStyle = .single
                    config.attributedTitle = AttributedString("\(sectionTitle)", attributes: container)
                    button.configuration = config
                    
                }else{
                    
                    let attributedText = NSMutableAttributedString(string: "  ")
                    attributedText.append(NSAttributedString(string: "\(sectionTitle)", attributes: [
                        .font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any,
                        .foregroundColor : UIColor.apTintColor as Any,
                        .underlineStyle : NSUnderlineStyle.single.rawValue
                    ]))
                    button.setAttributedTitle(attributedText, for: .normal)
                    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
                }
                
                button.tag = index+1
                
                button.contentHorizontalAlignment = .leading
                button.tintColor = .clear
                button.setImage(UIImage(named: "Checkbox"), for: .normal)
                button.setImage(UIImage(named: "Checkbox-Selected"), for: .selected)
                
                button.addTarget(self, action: #selector(didTapCheckbox(_:)), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                
                button.accessibilityLabel = "checkbox"
                
                checkboxesListStackView.addArrangedSubview(button)
                
            }
        }
    }
    
    lazy var customSectionView: UIStackView = {
        
        let commonTag = arrayOfSections.count+1
        
        let textField = customFormField(LCtitle: "Ex : Custom Lorem Vlad", topText: "#Custom section")
        textField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.7).isActive = true
        textField.delegate = self
        textField.tag = commonTag
        
        textField.addTarget(self, action: #selector(didChangeField), for: .editingChanged)
        
        lazy var checkBoxButton: UIButton = {
            let button = UIButton(type: .custom)
            
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.plain()
                config.imagePadding = 8
                config.contentInsets.leading = 0
                button.configuration = config
            }else{
                button.contentEdgeInsets.right = 10
            }
            
            button.contentHorizontalAlignment = .leading
            
            button.tintColor = .clear
            button.setImage(UIImage(named: "Checkbox"), for: .normal)
            button.setImage(UIImage(named: "Checkbox-Selected"), for: .selected)

            button.tag = commonTag
            button.accessibilityLabel = "checkbox"
            button.addTarget(self, action: #selector(didTapCheckbox(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        let _stack = UIStackView(arrangedSubviews: [checkBoxButton, textField])
        
        _stack.axis = .horizontal
        _stack.isLayoutMarginsRelativeArrangement = true
        _stack.layoutMargins = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        
        _stack.translatesAutoresizingMaskIntoConstraints = false
        
        return _stack
    }()
    
    @objc func didTapPrevious(){
        if let target = popTo(MainSectionVC.self), target == false {
            let _initVC = MainSectionVC()
            _initVC.initialObject = initialObject
            self.navigationController?.pushViewController(_initVC, animated: true)
        }
    }
    
    
    //MARK: - Previous Button
    lazy var previousVCButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back-arrow")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapPrevious), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        let icon = NSTextAttachment()
        icon.image = UIImage(named: "customsection")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
        icon.bounds = CGRect(x: 0, y: -4, width: icon.image!.size.width, height: icon.image!.size.width)

        let attachement = NSAttributedString(attachment: icon)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(attachement)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: "Add Section", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 18) as Any, .foregroundColor : UIColor.apTintColor as Any]))
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "Add additional sections to your resume", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Final Buttons
    lazy var continueButton: UIButton = {
        var button = UIButton(type: .system)
        let imgsz = UIImageView()
        imgsz.accessibilityLabel = "ContinueButtonImage"
        imgsz.image = UIImage(named: "arrow-right")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        imgsz.contentMode = .scaleAspectFit
        imgsz.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "Add section", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any, .foregroundColor : UIColor.white as Any ])
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = .apContinueButton
        button.layer.cornerRadius = 3
        button.addSubview(imgsz)
        imgsz.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        imgsz.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        var button = UIButton(type: .system)

        let attributedText = NSMutableAttributedString(string: "Cancel",
                                                       attributes: [
                                                        .font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any,
                                                        .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8) as Any])
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = .apBackground
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.apBorderJobCell.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backButton, continueButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        
        continueButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var checkboxesListStackView: UIStackView = {
        let _stack = UIStackView()
        _stack.axis = .vertical
        _stack.distribution = .fill
        _stack.isLayoutMarginsRelativeArrangement = true
        _stack.layoutMargins = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        
        _stack.translatesAutoresizingMaskIntoConstraints = false
        return _stack
    }()
    
    
    //MARK: - Functions

    @objc func didTapCheckbox(_ sender: UIButton){
        sender.isSelected.toggle()
    }
    
    private func checkboxesListStackViewCheckboxes() -> [MainSections] {
        var choosedSections: [MainSections] = []
        
        for (_, sView) in checkboxesListStackView.subviews.enumerated() where sView is UIButton && sView.accessibilityLabel == "checkbox" {
            
            let checkbox = sView as! UIButton
            if checkbox.isSelected != true { continue }
            
            let index = checkbox.tag - 1
            let section = arrayOfSections[index]
            choosedSections.append(section)
        }
        
        return choosedSections
    }
    
    private func customSectionViewCheckboxes() -> MainSections? {
        for (_, sView) in customSectionView.subviews.enumerated() where sView is UITextField {
            let textfield = sView as! customFormField
            if let text = textfield.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let customSection = MainSections.custom(title: text)
                return customSection
            }
        }
        return nil
    }
    
    @objc func didChangeField(textField: UITextField){
        let commonTag = textField.tag
        for (_, sView) in customSectionView.subviews.enumerated() where sView is UIButton && sView.tag == commonTag {
            let checkBoxButton = sView as! UIButton
            
            if let text = textField.text, text.isEmpty  {
                checkBoxButton.isSelected = false
            }else{
                checkBoxButton.isSelected = true
            }
        }
    }
    
    
    @objc func didTapContinue(){
        
        //1. update status to true for checked section
        var sections = checkboxesListStackViewCheckboxes() // Suggested List
        
        if let section = customSectionViewCheckboxes() {
            sections.append(section)
        }
        
        CoreDataManager.shared.setupSuggestedSections(sections: sections, initialObject: initialObject) { [weak self] _ in
            
            self?.passData?(self?.initialObject)
            
            if let target = self?.popTo(MainSectionVC.self), target == false {
                let _initVC = MainSectionVC()
                self?.navigationController?.pushViewController(_initVC, animated: true)
            }
        }
    }
    
    
    @objc func didTapCancel(){

        if let target = popTo(MainSectionVC.self), target == false {
            let _initVC = MainSectionVC()
            self.navigationController?.pushViewController(_initVC, animated: true)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        backButton.backgroundColor = .apBackground
        backButton.layer.borderColor = UIColor.apBorderJobCell.cgColor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .apBackground
        
        view.hideKeyboard()
        
        //MARK: - Fix Scroll Template
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let bottomAnchor = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        bottomAnchor.priority = UILayoutPriority(250)
        
        let centerYAnchor = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        centerYAnchor.priority = UILayoutPriority(250)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            centerYAnchor,
            bottomAnchor,
        ])
        
        contentView.addSubview(previousVCButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(sloganLabel)
        
        contentView.addSubview(checkboxesListStackView)
        contentView.addSubview(customSectionView)
        
        contentView.addSubview(buttonsStack)
        
        let weakConstraint: NSLayoutConstraint = checkboxesListStackView.heightAnchor.constraint(equalToConstant: 0)
        weakConstraint.priority = UILayoutPriority(250)
        
        NSLayoutConstraint.activate([
            previousVCButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            previousVCButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: previousVCButton.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: previousVCButton.leadingAnchor, constant: 0),
            
            sloganLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            sloganLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            sloganLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            sloganLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            checkboxesListStackView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 25),
            checkboxesListStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            checkboxesListStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            weakConstraint,
            
            customSectionView.topAnchor.constraint(equalTo: checkboxesListStackView.bottomAnchor, constant: 100),
            customSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            buttonsStack.topAnchor.constraint(equalTo: customSectionView.bottomAnchor, constant: 100),
            
            buttonsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonsStack.heightAnchor.constraint(equalToConstant: 40),

            buttonsStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
        
    }
}


extension AddSectionVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
