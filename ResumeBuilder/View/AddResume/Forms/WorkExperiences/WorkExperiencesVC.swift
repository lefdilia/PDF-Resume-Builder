//
//  WorkExperiencesVC.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 5/1/2022.
//

import UIKit
import CoreData


class WorkExperiencesVC: UIViewController, UIScrollViewDelegate {
    
    weak var initialObject: Initial?
    var objectId: NSManagedObjectID?
    
    var work: WorkExperiences? {
        didSet {
            //grab ObjectId
            objectId = work?.objectID
                        
            //MARK: - Change Title Label
            let icon = NSTextAttachment()
            icon.image = UIImage(named: "Edit-Icon")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
            icon.bounds = CGRect(x: 0, y: titleLabel.font.descender, width: icon.image!.size.width, height: icon.image!.size.height)

            let attributedText = NSMutableAttributedString(string: "")
            attributedText.append(NSAttributedString(attachment: icon))
            attributedText.append(NSAttributedString(string: " "))
            attributedText.append(NSAttributedString(string: "Edit Work Experience", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 18) as Any, .foregroundColor : UIColor.apTintColor as Any]))
            
            titleLabel.attributedText = attributedText
            
            //MARK: - Textfields Value
            
            guard let work = work else { return }

            jobTitleTextField.text = work.jobTitle
            companyTextField.text = work.company
            cityTextField.text = work.city
            
            if let responsibilities = work.responsibilities {
                let _responsibilities = responsibilities.joined(separator: "\n")

                self.responsibilities.text = _responsibilities
                textViewDidChange(self.responsibilities)
            }
            
            //Country Drop Down Menu
            if let country = work.country {
                selectedItem["country"] = country
                let countryAttributedText = NSMutableAttributedString(string: country, attributes: [
                    .font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any,
                    .foregroundColor: UIColor.apTintColor ])
                self.countryeOptionMenu.setAttributedTitle(countryAttributedText, for: .normal)
                if #available(iOS 15.0, *) {
                    self.countryeOptionMenu.setNeedsUpdateConfiguration()
                }
            }
            
            //startMonthOptionMenu
            if let startDate = work.startDate {
                //startDate (2018-03-01 00:00:00 +0000)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM"

                let tempDate = formatter.string(from: startDate).components(separatedBy: "-") // 2018-03
                
                //Start Year
                let _selectedYear = tempDate[0]
                let attributedText = NSMutableAttributedString(string: _selectedYear, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor ])
                self.startYearOptionMenu.setAttributedTitle(attributedText, for: .normal)
                if #available(iOS 15.0, *) {
                    self.startYearOptionMenu.setNeedsUpdateConfiguration()
                }

                //Start Month
                if let _startMonth = Int(tempDate[1]) {
                    let selectedMonth = self._months[_startMonth-1]
                    let attributedText = NSMutableAttributedString(string: selectedMonth, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor ])
                    self.startMonthOptionMenu.setAttributedTitle(attributedText, for: .normal)
                    if #available(iOS 15.0, *) {
                        self.startMonthOptionMenu.setNeedsUpdateConfiguration()
                    }
                }
            }

            if let endDate = work.endDate {
                // endDate  2019-06-20 11:28:34 +0000
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM"
                
                let tempDate = formatter.string(from: endDate).components(separatedBy: "-") // 2018-03
                
                //End Year
                let _selectedYear = tempDate[0]
                let attributedText = NSMutableAttributedString(string: _selectedYear, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor ])
                self.endYearOptionMenu.setAttributedTitle(attributedText, for: .normal)
                if #available(iOS 15.0, *) {
                    self.endYearOptionMenu.setNeedsUpdateConfiguration()
                }

                //End Month
                if let _startMonth = Int(tempDate[1]) {
                    let selectedMonth = self._months[_startMonth-1]
                    let attributedText = NSMutableAttributedString(string: selectedMonth, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor ])
                    self.endMonthOptionMenu.setAttributedTitle(attributedText, for: .normal)
                    if #available(iOS 15.0, *) {
                        self.endMonthOptionMenu.setNeedsUpdateConfiguration()
                    }
                }
            }else{
                self.checkBoxButton.isSelected = true
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
    
    lazy var closeVCButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        let icon = NSTextAttachment()
        icon.image = UIImage(named: "workExperience")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
        let attachement = NSAttributedString(attachment: icon)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(attachement)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: "Tell us about your most recent jobs", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 18) as Any, .foregroundColor : UIColor.apTintColor as Any]))

        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "Show off your professional experience & responsibilities",
                                                attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var jobTitleTextField: customFormField = {
        let textField = customFormField(LCtitle: "Ex : e.g. Marketing Manager", topText: "Job Title")
        textField.tag = 1
        textField.delegate = self
        return textField
    }()
    
    lazy var companyTextField: customFormField = {
        let textField = customFormField(LCtitle: "Company / Organization Name")
        textField.tag = 2
        textField.delegate = self
        return textField
    }()
    
    lazy var cityTextField: customFormField = {
        let textField = customFormField(LCtitle: "City")
        textField.returnKeyType = .default
        textField.tag = 3
        textField.delegate = self
        return textField
    }()

    lazy var countryeOptionMenu: dropDownButton = {
        let button = dropDownButton(title: "Country")
        button.addTarget(self, action: #selector(didSelectCountry), for: .touchUpInside)
        return button
    }()
    
    lazy var startMonthOptionMenu: dropDownButton = {
        let button = dropDownButton(title: "Start Month")
        button.tag = 1
        button.addTarget(self, action: #selector(didSelectMonth(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var endMonthOptionMenu: dropDownButton = {
        let button = dropDownButton(title: "End Month")
        button.tag = 2
        button.addTarget(self, action: #selector(didSelectMonth(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var startYearOptionMenu: dropDownButton = {
        let button = dropDownButton(title: "Start Year")
        button.tag = 1
        button.addTarget(self, action: #selector(didSelectYear(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var endYearOptionMenu: dropDownButton = {
        let button = dropDownButton(title: "End Year")
        button.tag = 2
        button.addTarget(self, action: #selector(didSelectYear(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var checkBoxButton: UIButton = {
        let button = UIButton(type: .custom)
        
        if #available(iOS 15.0, *) {
            
            var config = UIButton.Configuration.plain()
            config.imagePadding = 8
            config.contentInsets.leading = 0
            
            var container = AttributeContainer()
            container.font = UIFont(name: Theme.nunitoSansSemiBold, size: 14)
            container.foregroundColor = UIColor.apTintColor
            container.underlineStyle = .single
            config.attributedTitle = AttributedString("I currently work here", attributes: container)
            button.configuration = config
            
        }else{
            
            let attributedText = NSMutableAttributedString(string: "  ")
            attributedText.append(NSAttributedString(string: "I currently work here", attributes: [
                .font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any,
                .foregroundColor : UIColor.apTintColor as Any,
                .underlineStyle : NSUnderlineStyle.single.rawValue
            ]))
            button.setAttributedTitle(attributedText, for: .normal)
        }
        
        button.tintColor = .clear
        button.setImage(UIImage(named: "Checkbox"), for: .normal)
        button.setImage(UIImage(named: "Checkbox-Selected"), for: .selected)
        
        button.addTarget(self, action: #selector(didTapCheckbox(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func didTapCheckbox(_ sender: UIButton){

        sender.isSelected.toggle()
        closeButtonTapped()
        if sender.isSelected {
            endYearOptionMenu.isEnabled = false
            endMonthOptionMenu.isEnabled = false
            
            endYearOptionMenu.isHidden = true
            endMonthOptionMenu.isHidden = true
            
            self.checkboxConstraint.constant = -(endMonthOptionMenu.frame.height)

        }else{
            endYearOptionMenu.isEnabled = true
            endMonthOptionMenu.isEnabled = true
            
            endYearOptionMenu.isHidden = false
            endMonthOptionMenu.isHidden = false
            
            self.checkboxConstraint.constant = 20

        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: - For Edit
        if self.checkBoxButton.isSelected == true && self.checkboxConstraint != nil && navigationController?.presentingViewController == nil {
            endYearOptionMenu.isEnabled = false
            endMonthOptionMenu.isEnabled = false
            endYearOptionMenu.isHidden = true
            endMonthOptionMenu.isHidden = true
            checkboxConstraint.constant = -(endMonthOptionMenu.frame.height)
        }
        
    }
    
    lazy var labelPlaceholder: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.attributedText = NSMutableAttributedString(string: "Type your achievements and responsibilities here", attributes: [.font : UIFont(name: Theme.nunitoSansItalic, size: 13) as Any, .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.5) as Any ])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var responsibilities: UITextView = {
        let textView = UITextView()

        textView.autocorrectionType = .no
        textView.backgroundColor = .apBackground
        textView.textColor = .apTintColor
        textView.tintColor = .apTintColor
        textView.font = UIFont(name: Theme.nunitoSansSemiBold, size: 14)

        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 0.8
        textView.layer.borderColor = UIColor.apBorderJobCell.cgColor
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.keyboardType = .alphabet
        
        textView.smartDashesType = .yes
        textView.delegate = self

        textView.addSubview(labelPlaceholder)
        labelPlaceholder.topAnchor.constraint(equalTo: textView.topAnchor, constant: 6).isActive = true
        labelPlaceholder.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5).isActive = true
        labelPlaceholder.widthAnchor.constraint(equalTo: textView.widthAnchor, multiplier: 0.95).isActive = true

        return textView
    }()

    lazy var tempTextView = UITextField(frame: .zero)
    lazy var tempTextView2 = UITextField(frame: .zero)
    lazy var tempTextView3 = UITextField(frame: .zero)

    lazy var _countriesPickerView = UIDataPicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
    lazy var _monthsPickerView = UIDataPicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
    lazy var _yearPickerView = UIDataPicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))

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
    
    //MARK: - Final Buttons
    lazy var continueButton: UIButton = {
        var button = UIButton(type: .system)
        let imgsz = UIImageView()
        imgsz.accessibilityLabel = "ContinueButtonImage"
        imgsz.image = UIImage(named: "arrow-right")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        imgsz.contentMode = .scaleAspectFit
        imgsz.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "Continue", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any, .foregroundColor : UIColor.white as Any ])
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
        let attributedText = NSMutableAttributedString(string: "Cancel", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8) as Any])
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
        
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
        
        if responsibilities.isFirstResponder {
            
            let distance = responsibilities.frame.minY-keyboardSize.height
            let listOfRolesCGPoint = CGPoint(x: 0, y: distance - responsibilities.frame.height+30)
            
            scrollView.setContentOffset(listOfRolesCGPoint, animated: true)
        }

    }

    @objc func keyboardWillHide(notification: NSNotification) {
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
          
      // reset back the content inset to zero after keyboard is gone
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
  }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        backButton.backgroundColor = .apBackground
        backButton.layer.borderColor = UIColor.apBorderJobCell.cgColor
        
        responsibilities.layer.borderColor = UIColor.apBorderJobCell.cgColor
    }
    
    var checkboxConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _countries.insert("", at: 0)
        
        view.backgroundColor = .apBackground

        if navigationController?.presentingViewController == nil {
            previousVCButton.isHidden = true
            closeVCButton.isHidden = false
            
            //Continue Button
            continueButton.setAttributedTitle(NSMutableAttributedString(string: "Save", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any, .foregroundColor : UIColor.white as Any]), for: .normal)
            continueButton.backgroundColor = .apUpdateButton
            _ = (continueButton.subviews.first { $0.accessibilityLabel == "ContinueButtonImage" } as? UIImageView)?.image = nil
            continueButton.layoutIfNeeded()
        }else{
            previousVCButton.isHidden = false
            closeVCButton.isHidden = true
        }
        
        backButton.backgroundColor = .apBackground
        backButton.layer.borderColor = UIColor.apBorderJobCell.cgColor
     
        //Hide keyboard after Edit
        view.hideKeyboard()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Init-Subviews
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
            bottomAnchor,
            centerYAnchor,
        ])
    
        //Country PickerView
        tempTextView.inputView = _countriesPickerView
        tempTextView.inputAccessoryView = doneToolbar
        _countriesPickerView.dataSource = self
        _countriesPickerView.delegate = self
        _countriesPickerView.tag = 1
        
        //Month PickerView
        tempTextView2.inputView = _monthsPickerView
        tempTextView2.inputAccessoryView = doneToolbar
        _monthsPickerView.dataSource = self
        _monthsPickerView.delegate = self
        _monthsPickerView.tag = 2
        
        //Year PickerView
        tempTextView3.inputView = _yearPickerView
        tempTextView3.inputAccessoryView = doneToolbar
        _yearPickerView.dataSource = self
        _yearPickerView.delegate = self
        _yearPickerView.tag = 3
        
        //Add-Subviews
        contentView.addSubview(tempTextView)
        contentView.addSubview(tempTextView2)
        contentView.addSubview(tempTextView3)
        //
        contentView.addSubview(previousVCButton)
        contentView.addSubview(closeVCButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(sloganLabel)
        
        contentView.addSubview(jobTitleTextField)
        contentView.addSubview(companyTextField)
        contentView.addSubview(countryeOptionMenu)
        contentView.addSubview(cityTextField)
        
        contentView.addSubview(startMonthOptionMenu)
        contentView.addSubview(startYearOptionMenu)
        contentView.addSubview(endMonthOptionMenu)
        contentView.addSubview(endYearOptionMenu)
        
        contentView.addSubview(checkBoxButton)
        contentView.addSubview(responsibilities)

        checkboxConstraint = checkBoxButton.topAnchor.constraint(equalTo: endMonthOptionMenu.bottomAnchor, constant: 20)
        
        contentView.addSubview(buttonsStack)
    
        NSLayoutConstraint.activate([
            
            previousVCButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            previousVCButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
    
            closeVCButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeVCButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: previousVCButton.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: previousVCButton.leadingAnchor, constant: 0),

            sloganLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            sloganLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            sloganLabel.heightAnchor.constraint(equalToConstant: 25),

            jobTitleTextField.topAnchor.constraint(equalToSystemSpacingBelow: sloganLabel.bottomAnchor, multiplier: 8),
            jobTitleTextField.leadingAnchor.constraint(equalTo: sloganLabel.leadingAnchor, constant: 0),
            jobTitleTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            jobTitleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            companyTextField.topAnchor.constraint(equalTo: jobTitleTextField.bottomAnchor, constant: 15),
            companyTextField.leadingAnchor.constraint(equalTo: sloganLabel.leadingAnchor, constant: 0),
            companyTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            companyTextField.heightAnchor.constraint(equalToConstant: 40),

            countryeOptionMenu.topAnchor.constraint(equalTo: companyTextField.bottomAnchor, constant: 15),
            countryeOptionMenu.leadingAnchor.constraint(equalTo: companyTextField.leadingAnchor, constant: 0),
            countryeOptionMenu.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            countryeOptionMenu.heightAnchor.constraint(equalToConstant: 40),
            
            cityTextField.topAnchor.constraint(equalTo: countryeOptionMenu.topAnchor ),
            cityTextField.leadingAnchor.constraint(equalTo: countryeOptionMenu.trailingAnchor, constant: 20),
            cityTextField.trailingAnchor.constraint(equalTo: companyTextField.trailingAnchor),
            cityTextField.heightAnchor.constraint(equalToConstant: 40),
            
            startMonthOptionMenu.topAnchor.constraint(equalTo: countryeOptionMenu.bottomAnchor, constant: 15),
            startMonthOptionMenu.leadingAnchor.constraint(equalTo: countryeOptionMenu.leadingAnchor, constant: 0),
            startMonthOptionMenu.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            startMonthOptionMenu.heightAnchor.constraint(equalToConstant: 40),

            startYearOptionMenu.topAnchor.constraint(equalTo: startMonthOptionMenu.topAnchor ),
            startYearOptionMenu.leadingAnchor.constraint(equalTo: startMonthOptionMenu.trailingAnchor, constant: 20),
            startYearOptionMenu.trailingAnchor.constraint(equalTo: cityTextField.trailingAnchor),
            startYearOptionMenu.heightAnchor.constraint(equalToConstant: 40),
            
            endMonthOptionMenu.topAnchor.constraint(equalTo: startMonthOptionMenu.bottomAnchor, constant: 15),
            endMonthOptionMenu.leadingAnchor.constraint(equalTo: startMonthOptionMenu.leadingAnchor, constant: 0),
            endMonthOptionMenu.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            endMonthOptionMenu.heightAnchor.constraint(equalToConstant: 40),

            endYearOptionMenu.topAnchor.constraint(equalTo: endMonthOptionMenu.topAnchor ),
            endYearOptionMenu.leadingAnchor.constraint(equalTo: endMonthOptionMenu.trailingAnchor, constant: 20),
            endYearOptionMenu.trailingAnchor.constraint(equalTo: cityTextField.trailingAnchor),
            endYearOptionMenu.heightAnchor.constraint(equalToConstant: 40),
            
            checkBoxButton.leadingAnchor.constraint(equalTo: endMonthOptionMenu.leadingAnchor),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 30),
            
            responsibilities.topAnchor.constraint(equalTo: checkBoxButton.bottomAnchor, constant: 10),
            responsibilities.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            responsibilities.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            responsibilities.heightAnchor.constraint(greaterThanOrEqualToConstant: 150),

            buttonsStack.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: responsibilities.bottomAnchor, multiplier: 7.5),
            buttonsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonsStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            
            buttonsStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -50)

        ])
        
        checkboxConstraint?.isActive = true
        
    }
    
    //MARK: - Functions
    
    @objc func didTapCancel(){
        
        if self.navigationController?.presentingViewController == nil {
            self.dismiss(animated: true, completion: nil)
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
        
        let jobtitle = jobTitleTextField.text ?? ""
        let companyName = companyTextField.text ?? ""
        let country = self.selectedItem["country"]
        let city = cityTextField.text
        
        let startYear = startYearOptionMenu.titleLabel?.text ?? "1900"
        let endYear = endYearOptionMenu.titleLabel?.text ?? "1900"
        
        //End Date Range
        var startDateRange: [String] = []
        if let startMonth = startMonthOptionMenu.titleLabel?.text, let _startMonth = _months.firstIndex(of: startMonth) {
            startDateRange.append(startYear)
            startDateRange.append(String(format: "%02d", _startMonth+1))
        }
        
        //End Date Range
        var endDateRange: [String] = []
        if let endMonth = endMonthOptionMenu.titleLabel?.text, let _endMonth = _months.firstIndex(of: endMonth) {
            endDateRange.append(endYear)
            endDateRange.append(String(format: "%02d", _endMonth+1))
        }
                
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        
        let startDate = formatter.date(from: startDateRange.joined(separator: "-")) ?? Date() //"Jan 1, 2011 at 12:00 AM"
        
        let endDate: Date? = checkBoxButton.isSelected == false ? formatter.date(from: endDateRange.joined(separator: "-")) : nil

        let _responsibilities: [String] = responsibilities.text.components(separatedBy: "\n")
            .map({ $0.replacingOccurrences(of: "•", with:"" ) })
            .map({ $0.replacingOccurrences(of: "^ {1,}", with: "", options: .regularExpression) })
            .filter({ !$0.isEmpty })
        
        var _options = WorkExperienceModel(jobTitle: jobtitle,
                                     company: companyName,
                                     country: country,
                                     city: city,
                                     startDate: startDate,
                                     endDate: endDate,
                                     responsibilities: _responsibilities)
    
        if let initialObject = initialObject {
            _options.initialObject = initialObject
        }
        
        var errors: [String] = []
        
        if (jobtitle.isEmpty) {
            errors.append("- Job Title Field is empty")
        }
        
        if (companyName.isEmpty) {
            errors.append("- Company Field is empty")
        }
        
        if (startDateRange.isEmpty) {
            errors.append("- Work start date information is required")
        }
        
        if (checkBoxButton.isSelected == false && endDateRange.isEmpty) {
            errors.append("- Work end date information is required")
        }

        
        if !errors.isEmpty {

            let alert = UIAlertController(title: "Empty Fields", message: errors.joined(separator: "\n"), preferredStyle: .actionSheet)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            
            let confirmAction = UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
                let workExperiencesListVC = WorkExperiencesListVC()
                workExperiencesListVC.initialObject = self?.initialObject
                self?.navigationController?.pushViewController(workExperiencesListVC, animated: true)
            }
            
            //check if is modaly o pushed to stack
            if self.navigationController?.presentingViewController != nil {
                alert.addAction(confirmAction)
            }

            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        
        }else{
            
            CoreDataManager.shared.setupWorkExperiences(options: _options, objectId: self.objectId) { [weak self] _ in
                
                if self?.navigationController?.presentingViewController == nil {
                    self?.dismiss(animated: true) {
                        self?.saveHandler?()
                    }
                }else{
                    let workExperiencesListVC = WorkExperiencesListVC()
                    workExperiencesListVC.initialObject = initialObject
                    self?.navigationController?.pushViewController(workExperiencesListVC, animated: true)
                }
                
            }
        }
    }
    
    var saveHandler: (()->())?

    var _countries: [String] = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
    let _months: [String] = DateFormatter().monthSymbols.map({ $0.capitalized })
    
    let _currentYear = Calendar.current.component(.year, from: Date())
    lazy var _years = (1900..._currentYear).map { String($0) }
    
    lazy var selectedItem: [String: String] = ["country": "Austria"]
    
    @objc func didSelectCountry(){
        self.tempTextView.becomeFirstResponder()
        
        var _index = 1
        if let _selectedValueindex = _countries.firstIndex(of: selectedItem["country"]!) {
            _index = _selectedValueindex
        }
        
        self._countriesPickerView.selectRow(_index, inComponent: 0, animated: true)
    }
    
    @objc func didSelectMonth(_ sender: UIButton){
        self.tempTextView2.becomeFirstResponder()
        self.tempTextView2.tag = sender.tag
        
        let dropDownLabel = sender.titleLabel?.text ?? "February"

        var _index = 0
        if sender.tag == 1 {
            let title = dropDownLabel == "Start Month" ? "February" : dropDownLabel

            if let _selectedValueindex = _months.firstIndex(of: title) {
                _index = _selectedValueindex
            }
        }
        
        if sender.tag == 2 {
            let title = dropDownLabel == "End Month" ? "September" : dropDownLabel
            if let _selectedValueindex = _months.firstIndex(of: title) {
                _index = _selectedValueindex
            }
        }
        
        self._monthsPickerView.selectRow(_index, inComponent: 0, animated: true)
    }
    
    @objc func didSelectYear(_ sender: UIButton){
        
        self.tempTextView3.becomeFirstResponder()
        self.tempTextView3.tag = sender.tag

        let dropDownLabel = sender.titleLabel?.text ?? "\(_currentYear)"

        var _index = 10
        if sender.tag == 1 {
            let title = dropDownLabel == "Start Year" ? "\(_currentYear-4)" : dropDownLabel
            if let _selectedValueindex = _years.firstIndex(of: title) {
                _index = _selectedValueindex
            }
        }
        
        if sender.tag == 2 {
            let title = dropDownLabel == "End Year" ? "\(_currentYear)" : dropDownLabel
            if let _selectedValueindex = _years.firstIndex(of: title) {//
                _index = _selectedValueindex
            }
        }

        self._yearPickerView.selectRow(_index, inComponent: 0, animated: true)
    }

    @objc func doneButtonTapped(sender: UIBarButtonItem){
        
        if tempTextView.isFirstResponder {
            
            let country = self.selectedItem["country"]!
            let attributedText = NSMutableAttributedString(string: country, attributes: [
                .font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any,
                .foregroundColor: UIColor.apTintColor ])
            self.countryeOptionMenu.setAttributedTitle(attributedText, for: .normal)
            if #available(iOS 15.0, *) {
                self.countryeOptionMenu.setNeedsUpdateConfiguration()
            }
            
        }
        
        if tempTextView2.isFirstResponder {
        
            let indexRow = self._monthsPickerView.selectedRow(inComponent: 0)
            let selectedMonth = _months[indexRow]
            
            if tempTextView2.tag == 1 {
                let attributedText = NSMutableAttributedString(string: selectedMonth, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor ])
                self.startMonthOptionMenu.setAttributedTitle(attributedText, for: .normal)
                if #available(iOS 15.0, *) {
                    self.startMonthOptionMenu.setNeedsUpdateConfiguration()
                }
            }
            
            if tempTextView2.tag == 2 {
                let attributedText = NSMutableAttributedString(string: selectedMonth, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor ])
                self.endMonthOptionMenu.setAttributedTitle(attributedText, for: .normal)
                if #available(iOS 15.0, *) {
                    self.endMonthOptionMenu.setNeedsUpdateConfiguration()
                }
            }
        }
        
        
        if tempTextView3.isFirstResponder {
            let indexRow = self._yearPickerView.selectedRow(inComponent: 0)
            let selectedYear = _years[indexRow]
            
            if tempTextView3.tag == 1 {
            let attributedText = NSMutableAttributedString(string: selectedYear, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor ])
                self.startYearOptionMenu.setAttributedTitle(attributedText, for: .normal)
                if #available(iOS 15.0, *) {
                    self.startYearOptionMenu.setNeedsUpdateConfiguration()
                }
            }
            
            if tempTextView3.tag == 2 {
                let attributedText = NSMutableAttributedString(string: selectedYear, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor ])
                self.endYearOptionMenu.setAttributedTitle(attributedText, for: .normal)
                if #available(iOS 15.0, *) {
                    self.endYearOptionMenu.setNeedsUpdateConfiguration()
                }
            }
        }
        
        closeButtonTapped()
    }
    
    @objc func closeButtonTapped(){
        tempTextView.resignFirstResponder()
        tempTextView2.resignFirstResponder()
        tempTextView3.resignFirstResponder()
    }
    
    @objc func didTapPrevious(){
        
        if let target = popTo(MainSectionVC.self), target == false {
            let _initVC = MainSectionVC()
            _initVC.initialObject = initialObject
            self.navigationController?.pushViewController(_initVC, animated: true)
        }
    }
    
    @objc func didTapClose(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension WorkExperiencesVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        //MARK: - Hide Placeholder
        let newAlpha: CGFloat = textView.text.isEmpty ? 1 : 0
        if labelPlaceholder.alpha != newAlpha {
            UIView.animate(withDuration: 0.2) {
                self.labelPlaceholder.alpha = newAlpha
            }
        }
    }
    
}
    
extension WorkExperiencesVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tagBasedTextField(textField)
        return true
    }
    
    private func tagBasedTextField(_ textField: UITextField) {
        let nextTextFieldTag = textField.tag + 1
        
        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            responsibilities.becomeFirstResponder()
        }
    }
    
}
