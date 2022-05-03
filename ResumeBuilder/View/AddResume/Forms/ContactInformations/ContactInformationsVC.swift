//
//  ContactInformationsVC.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 29/12/2021.
//

import UIKit
import CoreData

class ContactInformationsVC: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var objectId: NSManagedObjectID?
    
    var presentingMainSection: Bool?
    
    var initialObject: Initial? {
        didSet{
            
            if let contactInformation = initialObject?.contactInformations?.allObjects.first as? ContactInformations {
                
                objectId = contactInformation.objectID
                
                //MARK: - Update Image
                if let photoData = contactInformation.photo {
                    let image = UIImage(data: photoData)
                    profileImagePicker.image = image
                }
                
                //MARK: - Texfield Update
                firstNameTextField.text = contactInformation.firstName
                lastNameTextField.text = contactInformation.lastName
                professionTextField.text = contactInformation.profession
                addressTextField.text = contactInformation.address
                stateTextField.text = contactInformation.state
                cityTextField.text = contactInformation.city
                zipCodeTextField.text = contactInformation.zipCode
                phoneTextField.text = contactInformation.phone
                emailTextField.text = contactInformation.email
                
                //MARK: - Update
                selectedItem["country"] = contactInformation.country
                
                if let country = contactInformation.country {
                    let attributedText = NSMutableAttributedString(string: country, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor ])
                    self.countryeOptionMenu.setAttributedTitle(attributedText, for: .normal)
                    
                    if #available(iOS 15.0, *) {
                        self.countryeOptionMenu.setNeedsUpdateConfiguration()
                    }
                }
                
                //MARK: - Social Links
                if let socialLinks = contactInformation.socialLinks {
                    for social in socialLinks {
                        addSocialLinks(list: social) // Need to scroll to bottom
                    }
                }
            }
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "What's your contact information ?", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 18) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "We suggest including an email and phone number.", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addIcon: UIImageView = {
        let addIcon = UIImageView()
        addIcon.translatesAutoresizingMaskIntoConstraints = false
        addIcon.contentMode = .scaleAspectFill
        addIcon.image = UIImage(named: "add-photo")?.withRenderingMode(.alwaysOriginal)
        addIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        addIcon.layer.cornerRadius = 15
        addIcon.layer.borderWidth = 1.5
        addIcon.layer.borderColor = UIColor.saltBox.withAlphaComponent(0.3).cgColor
        
        addIcon.layer.masksToBounds = true
        addIcon.clipsToBounds = true
        addIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectedPhoto)))
        addIcon.isUserInteractionEnabled = true
        
        return addIcon
    }()
    
    
    lazy var profileImagePicker: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "photoPlaceHolder")?.withRenderingMode(.alwaysOriginal)
        
        imageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        imageView.layer.cornerRadius = 45
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor.saltBox.withAlphaComponent(0.3).cgColor
        
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectedPhoto)))
        
        return imageView
    }()
    
    let imagePicketController = UIImagePickerController()
    
    @objc func handleSelectedPhoto(){
        imagePicketController.delegate = self
        imagePicketController.allowsEditing = true
        
        present(imagePicketController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage]{
            profileImagePicker.image = editedImage as? UIImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage]{
            profileImagePicker.image = originalImage as? UIImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Setup PickerView
    lazy var tempTextView = UITextField(frame: .zero)
    lazy var tempTextView2 = UITextField(frame: .zero)
    
    lazy var _countriesPickerView = UIDataPicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
    lazy var _socialLinksPickerView = UIDataPicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
    
    lazy var doneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        toolbar.backgroundColor = .apTintColorLight
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 15.0), .foregroundColor: UIColor.apTintColor],for: .normal)
        doneButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 15.0), .foregroundColor: UIColor.apTintColor],for: .highlighted)
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))?.withTintColor(.apTintColor, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(closeButtonTapped))
        
        let items = [closeButton, flexSpace, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()
        
        return toolbar
    }()
    
    @objc func closeButtonTapped(){
        tempTextView.resignFirstResponder()
        tempTextView2.resignFirstResponder()
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem){
        
        if tempTextView.isFirstResponder {
            
            if let country = self.selectedItem["country"] {
                let attributedText = NSMutableAttributedString(string: country, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor ])
                self.countryeOptionMenu.setAttributedTitle(attributedText, for: .normal)
                if #available(iOS 15.0, *) {
                    self.countryeOptionMenu.setNeedsUpdateConfiguration()
                }
                
                stateTextField.becomeFirstResponder()
            }
            
        }

        if tempTextView2.isFirstResponder {
            if (self.currentButton != nil) {
                if let socialLink = self.selectedItem["socialLink"] {
                    let attributedText = NSMutableAttributedString(string: socialLink, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any])
                    self.currentButton?.setAttributedTitle(attributedText, for: .normal)
                    if #available(iOS 15.0, *) {
                        self.currentButton?.setNeedsUpdateConfiguration()
                    }
                }
            }
        }
        
        closeButtonTapped()
    }
    
    @objc func didSelectCountry(){
        self.tempTextView.becomeFirstResponder()
        
        var _index = 1
        if let _selectedValueindex = _countries.firstIndex(of: selectedItem["country"]!) {
            _index = _selectedValueindex
        }
        
        self._countriesPickerView.selectRow(_index, inComponent: 0, animated: true)
    }
    
    let _countries: [String] = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
    
    lazy var _socialLinks: [String:String] = ["Patreon": "@lefdilia",
                                              "Github":"@lefdilia",
                                              "Twitter":"@Iyoub",
                                              "Linkedin":"@lefdilia",
                                              "Medium":"@lefdilia",
                                              "Website":"https://wwwlefdilia.com",
                                              "Portfolio":"https://wwwlefdilia.com"]
    
    lazy var _tempSocialLinks: [String:String] = _socialLinks
    lazy var selectedItem: [String: String] = ["country": "Austria", "socialLink":""]
    
    //End-PickerView
    //Form Fields
    lazy var countryeOptionMenu: dropDownButton = {
        let button = dropDownButton(title: "Country")
        button.addTarget(self, action: #selector(didSelectCountry), for: .touchUpInside)
        return button
    }()
    
    lazy var firstNameTextField: customFormField = {
        let textField = customFormField(LCtitle: "First Name")
        textField.tag = 1
        textField.delegate = self
        return textField
    }()
    
    lazy var lastNameTextField: customFormField = {
        let textField = customFormField(LCtitle: "Last Name")
        textField.tag = 2
        textField.delegate = self
        return textField
    }()
    
    lazy var professionTextField: customFormField = {
        let textField = customFormField(LCtitle: "Profession")
        textField.tag = 3
        textField.delegate = self
        textField.autocapitalizationType = .words
        return textField
    }()
    
    lazy var addressTextField: customFormField = {
        let textField = customFormField(LCtitle: "Address")
        textField.tag = 4
        textField.delegate = self
        return textField
    }()
    
    lazy var stateTextField: customFormField = {
        let textField = customFormField(LCtitle: "State")
        textField.tag = 5
        textField.delegate = self
        return textField
    }()
    
    lazy var cityTextField: customFormField = {
        let textField = customFormField(LCtitle: "City")
        textField.tag = 6
        textField.delegate = self
        return textField
    }()
    
    lazy var zipCodeTextField: customFormField = {
        let textField = customFormField(LCtitle: "Zip Code")
        textField.tag = 7
        textField.delegate = self
        return textField
    }()
    
    lazy var phoneTextField: customFormField = {
        let textField = customFormField(LCtitle: "Phone")
        textField.tag = 8
        textField.delegate = self
        return textField
    }()
    
    lazy var emailTextField: customFormField = {
        let textField = customFormField(LCtitle: "E-mail")
        textField.tag = 9
        textField.delegate = self
        textField.autocapitalizationType = .none
        return textField
    }()
    
    var socialLinkHeightAnchor: NSLayoutConstraint!
    
    //Social Stack
    lazy var socialLinkContainer: UIStackView = {
        let _socialContainer = UIStackView()
        _socialContainer.axis = .vertical
        _socialContainer.spacing = 15
        _socialContainer.translatesAutoresizingMaskIntoConstraints = false
        return _socialContainer
    }()
    
    lazy var addSocialLinksButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "link", withConfiguration: UIImage.SymbolConfiguration(scale: .small))?.withTintColor(.apSocialLinksButton).withRenderingMode(.alwaysOriginal)
        
        let attributedText = NSMutableAttributedString(string: "")

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 4
            config.image = image
            config.buttonSize = .medium
            button.configuration = config
            
        }else{
            
            let icon = NSTextAttachment()
            icon.image = image
            icon.bounds = CGRect(x: 0, y: -4, width: icon.image!.size.width, height: icon.image!.size.width )
            
            let attachement = NSAttributedString(attachment: icon)
            attributedText.append(attachement)
            attributedText.append(NSAttributedString(string: " "))
        }
        
        attributedText.append(NSAttributedString(string: "Add social links", attributes: [
            .font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any,
            .foregroundColor : UIColor.apSocialLinksButton as Any
        ]))
        
        button.setAttributedTitle(attributedText, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addSocialLink), for: .touchUpInside)
        return button
    }()
    
    
    var currentButton: UIButton?
    
    @objc func addSocialLink(){
        addSocialLinks()
    }
    
    func addSocialLinks(list: (key:String, value:String)? = nil){
        
        let socialContainer = CustomSocialContainer()
        socialContainer.tag = Int(arc4random())
        
        socialContainer.socialLinkTrigger = { [weak self] textfield in
            
            if let count = self?._tempSocialLinks.count, count <= 0 {
                textfield.resignFirstResponder()
                return
            }
            self?.addSocialLink()
        }
        
        var _buttonTitle: String?
        var _textFieldValue: String?
        
        if let list = list {
            let _key = list.key, _value = list.value
            
            _buttonTitle = _key
            _textFieldValue = _value
            _tempSocialLinks.removeValue(forKey: _key)
            
        }else{
            if let (_key, _) = _tempSocialLinks.popFirst() {
                _buttonTitle = _key
            }
        }
        
        let attributedText = NSMutableAttributedString(string: _buttonTitle ?? "", attributes: [
            .font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any])
        
        socialContainer.socialSourcesOptionMenu.setAttributedTitle(attributedText, for: .normal)
        
        let attributedPlaceHodler = NSAttributedString(string: "Please type here", attributes: [ .font : UIFont(name: Theme.nunitoSansItalic, size: 14) as Any, .strokeColor : UIColor.apTintColor ])
        
        socialContainer.socialLinkTextField.attributedPlaceholder = attributedPlaceHodler
        
        if let _textFieldValue = _textFieldValue {
            socialContainer.socialLinkTextField.text = _textFieldValue
        }
        
        socialLinkContainer.addArrangedSubview(socialContainer)
        
        socialLinkContainer.setNeedsLayout()
        socialLinkContainer.layoutIfNeeded()
        
        socialContainer.socialLinkTextField.becomeFirstResponder()
        
        socialContainer.handler = { [weak self] button in
            self?.socialLinkContainer.subviews.first { _view in
                if _view.tag == button.tag {
                    for sView in _view.subviews {
                        if sView is UIButton, sView.tag == button.tag, sView.accessibilityLabel == "socialLabel", let _button = sView as? UIButton  {
                            if let _removedTitle = _button.titleLabel?.text {
                                self?._tempSocialLinks[_removedTitle] = self?._socialLinks[_removedTitle]
                            }
                        }
                    }
                }
                return _view.tag == button.tag
            }?.removeFromSuperview()
            
            if self?.socialLinkContainer.subviews.count == 0 {
                
                let image = UIImage(systemName: "link", withConfiguration: UIImage.SymbolConfiguration(scale: .small))?.withTintColor(.apSocialLinksButton).withRenderingMode(.alwaysOriginal)
                
                let attributedText = NSMutableAttributedString(string: "")
                
                if #available(iOS 15.0, *) {
                    var config = self?.addSocialLinksButton.configuration
                    config?.image = image
                    self?.addSocialLinksButton.configuration = config
                    self?.addSocialLinksButton.updateConfiguration()
                }else{
                    let icon = NSTextAttachment()
                    icon.image = image
                    icon.bounds = CGRect(x: 0, y: -4, width: icon.image!.size.width, height: icon.image!.size.width )
                    let attachement = NSAttributedString(attachment: icon)
                    attributedText.append(attachement)
                    attributedText.append(NSAttributedString(string: " "))
                }
                
                attributedText.append(NSMutableAttributedString(string: "Add social links", attributes: [
                    .font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any,
                    .foregroundColor : UIColor.apSocialLinksButton as Any]))
                
                self?.addSocialLinksButton.setAttributedTitle(attributedText, for: .normal)
                
                self?.addSocialLinksButton.setNeedsLayout()
                
                if #available(iOS 15.0, *) {
                    self?.addSocialLinksButton.updateConfiguration()
                }
                
                self?.scrollView.scrollToBottom(animated: true, toTop: true)
            }
            
            if self?.socialLinkContainer.subviews.count == self?._socialLinks.count  {
                self?.addSocialLinksButton.isHidden = true
            }else{
                self?.addSocialLinksButton.isHidden = false
            }
        }
        
        socialContainer.pickerHanlder = { [weak self] button in
            
            self?.currentButton = button
            
            self?.tempTextView2.becomeFirstResponder()
            self?.tempTextView2.tag = button.tag
            
            let _inputTitle = button.titleLabel?.text ?? ""
            
            var _index = 0
            if let _selectedValueindex = self?._socialLinks.keys.sorted().firstIndex(of: _inputTitle ) {
                _index = _selectedValueindex
            }
            self?._socialLinksPickerView.selectRow(_index, inComponent: 0, animated: true)
        }
        
        if socialLinkContainer.subviews.count > 0 {
            
            let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(scale: .small))?.withTintColor(.apSocialLinksButton).withRenderingMode(.alwaysOriginal)
            
            let attributedText = NSMutableAttributedString(string: "")
            
            if #available(iOS 15.0, *) {
                var config = addSocialLinksButton.configuration
                config?.image = image
                addSocialLinksButton.configuration = config
                addSocialLinksButton.updateConfiguration()
            }else{
                let icon = NSTextAttachment()
                icon.image = image
                icon.bounds = CGRect(x: 0, y: -4, width: icon.image!.size.width, height: icon.image!.size.width )
                let attachement = NSAttributedString(attachment: icon)
                attributedText.append(attachement)
                attributedText.append(NSAttributedString(string: " "))
            }
            
            attributedText.append(NSMutableAttributedString(string: "Add More", attributes: [
                .font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any,
                .foregroundColor : UIColor.apSocialLinksButton as Any]))
            
            addSocialLinksButton.setAttributedTitle(attributedText, for: .normal)
            
            if #available(iOS 15.0, *) {
                addSocialLinksButton.updateConfiguration()
            }
            
        }
        
        if socialLinkContainer.subviews.count == _socialLinks.count  {
            addSocialLinksButton.isHidden = true
        }
    }
    
    var SocialLinks = [String:String]()
    
    @objc func didTapCancel(){
        if presentingMainSection == true {
            didTapPrevious()
        }else{
            
            let alert = UIAlertController(title: "Unsaved Changes", message: "There are unsaved changes, do you want to discard them?", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Discard Changes", style: .destructive) { [weak self] _ in
                if let objectId = self?.initialObject?.objectID {
                    CoreDataManager.shared.deleteResume(objectId: objectId) { _ in
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func didTapContinue(){
        
        for sview in socialLinkContainer.subviews {
            for _view in sview.subviews {
                let _tag = _view.tag
                if _view is customFormField, let textField = _view as? customFormField {
                    for _view in sview.subviews {
                        if _view is UIButton, _view.tag == _tag, _view.accessibilityLabel == "socialLabel", let _button = _view as? UIButton  {
                            if let _source = _button.titleLabel?.text, let _socialLink = textField.text {
                                SocialLinks[_source] = _socialLink
                            }
                        }
                    }
                }
            }
        }
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let profession = professionTextField.text
        let address = addressTextField.text
        let country = selectedItem["country"]
        let state = stateTextField.text
        let city = cityTextField.text
        let zipCode = zipCodeTextField.text
        let phone = phoneTextField.text
        let email = emailTextField.text
        
        let socialLinks = SocialLinks.filter({ !$0.value.isEmpty })
        
        var photo: Data?
        if let profilePicture = profileImagePicker.image {
            photo = profilePicture.pngData()
        }
        
        var _options = PersonalInformationsModel(firstName: firstName,lastName: lastName,profession: profession,address: address,country: country,state: state,city: city,zipCode: zipCode,phone: phone,email: email,socialLinks: socialLinks,photo: photo)
        
        if let initialObject = initialObject {
            _options.initialObject = initialObject
        }
        
        var errors: [String] = []
        
        if (firstName.isEmpty && !lastName.isEmpty) {
            errors.append("- First Name Cannot be empty")
        }
        
        if (lastName.isEmpty && !firstName.isEmpty) {
            errors.append("- Last Name Cannot be empty")
        }
        
        if (firstName.isEmpty && lastName.isEmpty) {
            errors = [" - First name and Last name are mandatory"]
        }
        
        
        if !errors.isEmpty {
            
            let alert = UIAlertController(title: "Empty Fields", message: errors.joined(separator: "\n"), preferredStyle: .actionSheet)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            CoreDataManager.shared.setupContactInformations(options: _options, objectId: objectId) {[weak self] _ in
                //Fix save button
                if self?.objectId == nil {
                    let workExperiencesVC = WorkExperiencesVC()
                    workExperiencesVC.initialObject = self?.initialObject
                    self?.navigationController?.pushViewController(workExperiencesVC, animated: true)
                }else{
                    self?.didTapPrevious()
                }
            }
            
        }
    }
    
    //MARK: - Final Buttons
    lazy var continueButton: UIButton = {
        var button = UIButton(type: .system)
        let imgsz = UIImageView()
        imgsz.image = UIImage(named: "arrow-right")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        imgsz.contentMode = .scaleAspectFit
        imgsz.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "Continue", attributes: [
            .font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any,
            .foregroundColor : UIColor.white as Any,
        ])
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
        
        var button = UIButton(type: .custom)
        let attributedText = NSMutableAttributedString(string: "Cancel",
                                                       attributes: [
                                                        .font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any,
                                                        .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8) as Any,
                                                       ])
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = .apBackground
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.apBorderJobCell.cgColor
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backButton, continueButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        var extraSpace = 30.0
        if let accessibilityLabel = self.findFirstResponder(inView: self.view)?.accessibilityLabel, accessibilityLabel == "SocialLinks"  {
            extraSpace += 5.0
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + extraSpace, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)// bottom: -60
        // reset back the content inset to zero after keyboard is gone
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        backButton.backgroundColor = .apBackground
        backButton.layer.borderColor = UIColor.apBorderJobCell.cgColor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Main Section Save Button
        
        if presentingMainSection == true && initialObject?.status == true {
            //Update
            let attributedText = NSMutableAttributedString(string: "Update", attributes: [
                .font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any,
                .foregroundColor: UIColor.white as Any])
            continueButton.backgroundColor = .apUpdateButton
            continueButton.setAttributedTitle(attributedText, for: .normal)
            
            let cancelAttributedText = NSMutableAttributedString(string: "Back", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8) as Any])
            backButton.setAttributedTitle(cancelAttributedText, for: .normal)
            
        }
        
        //MARK: - Setup Views
        view.backgroundColor = .apBackground
        view.hideKeyboard()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        
        //PickerView
        contentView.addSubview(tempTextView)
        tempTextView.inputView = _countriesPickerView
        tempTextView.inputAccessoryView = doneToolbar
        
        _countriesPickerView.dataSource = self
        _countriesPickerView.delegate = self
        _countriesPickerView.tag = 1
        
        contentView.addSubview(tempTextView2)
        tempTextView2.inputView = _socialLinksPickerView
        tempTextView2.inputAccessoryView = doneToolbar
        
        _socialLinksPickerView.dataSource = self
        _socialLinksPickerView.delegate = self
        _socialLinksPickerView.tag = 2
        
        //PickerView
        contentView.addSubview(previousVCButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(sloganLabel)
        
        //ImagePicker
        contentView.addSubview(profileImagePicker)
        contentView.addSubview(addIcon)
        
        //Texfields
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(professionTextField)
        contentView.addSubview(addressTextField)
        contentView.addSubview(countryeOptionMenu)
        contentView.addSubview(stateTextField)
        contentView.addSubview(cityTextField)
        contentView.addSubview(zipCodeTextField)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(emailTextField)
        
        socialLinkHeightAnchor = socialLinkContainer.heightAnchor.constraint(equalToConstant: 5)
        socialLinkHeightAnchor.priority = UILayoutPriority(250)
        
        contentView.addSubview(socialLinkContainer)
        contentView.addSubview(addSocialLinksButton)
        
        contentView.addSubview(buttonsStack)
        
        let buttonsStackWeakConstraint = buttonsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        buttonsStackWeakConstraint.priority = UILayoutPriority(250)
        
        NSLayoutConstraint.activate([
            
            previousVCButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            previousVCButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: previousVCButton.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: previousVCButton.leadingAnchor, constant: 0),
            
            sloganLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            sloganLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            
            profileImagePicker.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 15),
            profileImagePicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addIcon.centerYAnchor.constraint(equalTo: profileImagePicker.centerYAnchor, constant: 15),
            addIcon.trailingAnchor.constraint(equalTo: profileImagePicker.trailingAnchor, constant: 10),
            
            firstNameTextField.topAnchor.constraint(equalTo: profileImagePicker.bottomAnchor, constant: 15),
            firstNameTextField.leadingAnchor.constraint(equalTo: sloganLabel.leadingAnchor, constant: 0),
            firstNameTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 45),
            
            lastNameTextField.leadingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor, constant: 15),
            lastNameTextField.centerYAnchor.constraint(equalTo: firstNameTextField.centerYAnchor),
            lastNameTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 45),
            
            professionTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 15 ),
            professionTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor, constant: 0),
            professionTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            professionTextField.heightAnchor.constraint(equalToConstant: 45),
            
            addressTextField.topAnchor.constraint(equalTo: professionTextField.bottomAnchor, constant: 15 ),
            addressTextField.leadingAnchor.constraint(equalTo: professionTextField.leadingAnchor, constant: 0),
            addressTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            addressTextField.heightAnchor.constraint(equalToConstant: 45),
            
            countryeOptionMenu.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 15 ),
            countryeOptionMenu.leadingAnchor.constraint(equalTo: addressTextField.leadingAnchor, constant: 0),
            countryeOptionMenu.heightAnchor.constraint(equalToConstant: 45),
            countryeOptionMenu.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            stateTextField.topAnchor.constraint(equalTo: countryeOptionMenu.topAnchor ),
            stateTextField.leadingAnchor.constraint(equalTo: countryeOptionMenu.trailingAnchor, constant: 20),
            stateTextField.trailingAnchor.constraint(equalTo: addressTextField.trailingAnchor),
            stateTextField.heightAnchor.constraint(equalToConstant: 45),
            
            cityTextField.topAnchor.constraint(equalTo: stateTextField.bottomAnchor, constant: 15 ),
            cityTextField.leadingAnchor.constraint(equalTo: addressTextField.leadingAnchor, constant: 0),
            cityTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            cityTextField.heightAnchor.constraint(equalToConstant: 45),
            
            zipCodeTextField.leadingAnchor.constraint(equalTo: cityTextField.trailingAnchor, constant: 20 ),
            zipCodeTextField.centerYAnchor.constraint(equalTo: cityTextField.centerYAnchor, constant: 0),
            zipCodeTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            zipCodeTextField.heightAnchor.constraint(equalToConstant: 45),
            
            phoneTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 15 ),
            phoneTextField.leadingAnchor.constraint(equalTo: cityTextField.leadingAnchor, constant: 0),
            phoneTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            phoneTextField.heightAnchor.constraint(equalToConstant: 45),
            
            emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 15 ),
            emailTextField.leadingAnchor.constraint(equalTo: phoneTextField.leadingAnchor, constant: 0),
            emailTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            emailTextField.heightAnchor.constraint(equalToConstant: 45),
            
            socialLinkContainer.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15 ),
            socialLinkContainer.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            socialLinkContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            socialLinkHeightAnchor,
            
            addSocialLinksButton.topAnchor.constraint(equalTo: socialLinkContainer.bottomAnchor, constant: 5),
            addSocialLinksButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            buttonsStack.topAnchor.constraint(equalTo: addSocialLinksButton.bottomAnchor, constant: 30),
            buttonsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonsStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            buttonsStackWeakConstraint
        ])
        
    }
    
    //MARK: - Functions
    @objc func didTapPrevious(){
        if let target = popTo(MainSectionVC.self), target == false {
            let _initVC = MainSectionVC()
            _initVC.initialObject = initialObject
            self.navigationController?.pushViewController(_initVC, animated: true)
        }
    }
    
}

//MARK: - Extension ( UITextFieldDelegate )
extension ContactInformationsVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tagBasedTextField(textField) {
            scrollView.scrollToBottom(animated: true)
        }
        return false
    }
    
    private func tagBasedTextField(_ textField: UITextField, done: ()->() ) {
        let nextTextFieldTag = textField.tag + 1
        
        if textField.tag == 4 {
            textField.resignFirstResponder()
            didSelectCountry()
        }else{
            if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
                nextTextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                done()
            }
        }
    }
    
    //MARK: - Helpers
    func findFirstResponder(inView view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder {
                return subView
            }
            
            if let recursiveSubView = findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }
        return nil
    }
}
