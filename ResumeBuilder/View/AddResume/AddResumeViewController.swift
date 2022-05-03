//
//  AddResumeViewController.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 1/12/2021.
//

import UIKit


class AddResumeViewController : UIViewController {
    
    var resumeTestData: ResumeData?
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close")?.withTintColor(.apTintColor), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    let topTextPresentation: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Please choose a template from one of recomendation below.\n Add your informations, download, and get the job.", attributes: [.foregroundColor : UIColor.apTintColor, .font: UIFont(name: "Avenir", size: 14) as Any])
        label.attributedText = attributedText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var chooseTemplateButton: UIButton = { [weak self] in
        let button = UIButton(type: .system)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .apChooseTemplate
            config.buttonSize = .medium
            config.background.cornerRadius = 4
            config.showsActivityIndicator = false
            config.imagePadding = 6
            config.titleAlignment = .center
            button.configuration = config
        } else {
            button.backgroundColor = .apChooseTemplate
            button.tintColor = .white
            button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
            button.layer.cornerRadius = 4
        }
            
        button.setAttributedTitle(NSAttributedString(string: "Choose Template", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 15) as Any]), for: .normal)
        button.addTarget(self, action: #selector(self?.didChooseTemplate), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    var listOfButtons: [UIButton] = []
    
    lazy var colorsStack: UIStackView = { [weak self] in
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 10
        
        let colors = TemplateColors.colors
        
        let HWSize = 40.0
        
        for (index, color) in colors.enumerated() {
            let _button = UIButton()
            
            _button.accessibilityLabel = "templateColor"
            _button.translatesAutoresizingMaskIntoConstraints = false
            
            if index == self?._color {
                _button.setImage(UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
            }
            
            _button.heightAnchor.constraint(equalToConstant: HWSize).isActive = true
            _button.widthAnchor.constraint(equalToConstant: HWSize).isActive = true
            
            _button.backgroundColor = color
            _button.layer.cornerRadius = HWSize/2
            _button.layer.borderWidth = 2
            
            _button.layer.masksToBounds = true
            _button.clipsToBounds = true
            
            _button.layer.borderColor = UIColor.mystic.cgColor
            
            _button.tag = index
            _button.addTarget(self, action: #selector(self?.didChangeColor(_:)), for: .touchUpInside)
            
            self?.listOfButtons.append(_button)
            stack.addArrangedSubview(_button)
        }
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let contentView: UIView = {
        let _view = UIView()

        _view.layer.cornerRadius = 10
        _view.layer.masksToBounds = true
        
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
    }()
    
    @objc func didSwipeTemplate(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
            self.didTapPreviousTemplate()
        }else{
            self.didTapNextTemplate()
        }
    }
    
    //MARK: - Functions
    @objc func didTapClose(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didChooseTemplate(){
        
        if #available(iOS 15, *) {
            var currentConfig = chooseTemplateButton.configuration
            currentConfig?.showsActivityIndicator = true
            chooseTemplateButton.configuration = currentConfig
            chooseTemplateButton.setNeedsUpdateConfiguration()
        }

        let attributedText = NSAttributedString(string: "Please wait...", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 15) as Any])
        chooseTemplateButton.setAttributedTitle(attributedText, for: .normal)
        
        CoreDataManager.shared.setupInitialDetail(options: selectedItem) { [weak self] (initialObject, error) in

            guard let initialObject = initialObject else { return }

            DispatchQueue.main.async {
                let contactInformationsVc = ContactInformationsVC()
                contactInformationsVc.initialObject = initialObject
                self?.navigationController?.pushViewController(contactInformationsVc, animated: true)
            }
        }
    }
    
    @objc func didTapNextTemplate(){
        if selectedTemplate < templatesList {
            selectedTemplate += 1
        }else{
            selectedTemplate = 0
        }
        
        TemplatesGenerator(template: selectedTemplate,
                           imageType: imageType,
                           resumeFont: resumeFont,
                           resumeSize: resumeSize,
                           templateColor: templateColor,
                           resumeData: resumeTestData).build { [weak self] template, _, _ in
            
            guard let template = template else { return }
            
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeTemplate(_:)))
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeTemplate(_:)))
            leftSwipe.direction = .left
            rightSwipe.direction = .right
            
            template.addGestureRecognizer(leftSwipe)
            template.addGestureRecognizer(rightSwipe)
            
            for _view in contentView.subviews {
                _view.removeFromSuperview()
            }
            
            contentView.addSubview(template)
            template.addSubview(chooseTemplateButton)
            
            let space = ceil(contentView.frame.height / 3)
            
            NSLayoutConstraint.activate([
                template.topAnchor.constraint(equalTo: contentView.topAnchor),
                template.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                template.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                template.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1),
                
                chooseTemplateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                chooseTemplateButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: space)
            ])

        }
        
        updateCounterLabel(selected: selectedTemplate, count: templatesList)
    }
    
    @objc func didTapPreviousTemplate(){
        if selectedTemplate > 0 {
            selectedTemplate -= 1
        }else if selectedTemplate == 0 {
            selectedTemplate = templatesList
        }
        
        
        TemplatesGenerator(template: selectedTemplate,
                           imageType: imageType,
                           resumeFont: resumeFont,
                           resumeSize: resumeSize,
                           templateColor: templateColor,
                           resumeData: resumeTestData).build { [weak self] template, _, _ in
            
            guard let template = template else { return }
            
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeTemplate(_:)))
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeTemplate(_:)))
            leftSwipe.direction = .left
            rightSwipe.direction = .right
            
            template.addGestureRecognizer(leftSwipe)
            template.addGestureRecognizer(rightSwipe)
            
            for _view in contentView.subviews {
                _view.removeFromSuperview()
            }
            
            contentView.addSubview(template)
            template.addSubview(chooseTemplateButton)
            
            let space = ceil(contentView.frame.height / 3)
            
            NSLayoutConstraint.activate([
                template.topAnchor.constraint(equalTo: contentView.topAnchor),
                template.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                template.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                template.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1),
                
                chooseTemplateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                chooseTemplateButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: space)
            ])
        }
        
        updateCounterLabel(selected: selectedTemplate, count: templatesList)
    }
    
    private func updateCounterLabel(selected: Int, count: Int){
        
        let _selected = selected+1
        let _count = count+1
        
        let attributes = NSMutableAttributedString(string: "\(_selected) of \(_count)", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 13) as Any, .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8) as Any ])
        
        self.templateLabelCounter.attributedText = attributes
    }
    
    
    @objc func didChangeColor(_ sender: UIButton) {
        
        for button in listOfButtons {
            button.setImage(nil, for: .normal)
        }
        
        let colorIndex = sender.tag
        //Set check image
        sender.setImage(UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        chooseTemplateButton.tag = colorIndex
        
        templateColor = Theme.TemplatesOptions.Templates.Colors(rawValue: colorIndex) ?? .RegalBlue
        
        TemplatesGenerator(template: selectedTemplate,
                           imageType: imageType,
                           resumeFont: resumeFont,
                           resumeSize: resumeSize,
                           templateColor: templateColor,
                           resumeData: resumeTestData).build { [weak self] template, _, _ in
            
            guard let template = template else { return }
            
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeTemplate(_:)))
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeTemplate(_:)))
            leftSwipe.direction = .left
            rightSwipe.direction = .right
            
            template.addGestureRecognizer(leftSwipe)
            template.addGestureRecognizer(rightSwipe)
            
            for _view in contentView.subviews {
                _view.removeFromSuperview()
            }
            
            contentView.addSubview(template)
            template.addSubview(chooseTemplateButton)
            
            let space = ceil(contentView.frame.height / 3)
            
            NSLayoutConstraint.activate([
                template.topAnchor.constraint(equalTo: contentView.topAnchor),
                template.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                template.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                template.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1),
                
                chooseTemplateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                chooseTemplateButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: space)
            ])
        }
        selectedItem["color"] = colorIndex
    }
    
    func choosedTemplate(selected: Int, resumeSize: ResumeSize, imageType: ImageType, font: Fonts) -> Templates {
        switch selected {
        case 0:
            return Templates.Cascade(size: resumeSize, imageType: imageType, font: font, colorOptions: templateColor, data: resumeTestData)
        case 1:
            return Templates.Enfold(size: resumeSize, imageType: imageType, font: font, colorOptions: templateColor, data: resumeTestData)
        default:
            return Templates.Cascade(size: resumeSize, imageType: imageType, font: font, colorOptions: templateColor, data: resumeTestData)
        }
    }
    
    var template: UIView!
    //Templates Available
    let templatesList = TemplatesType.allCases.count-1
    
    //MARK: - Default Values | Options
    var selectedTemplate = 0 {
        didSet{
            selectedItem["template"] = selectedTemplate
        }
    }
    
    var imageType: ImageType = .square
    var resumeFont: Fonts = .PTSans
    var resumeSize: ResumeSize = .A4
    
    lazy var templateColor: TemplatesColors = traitCollection.userInterfaceStyle == .dark ? .CuttySark : .RegalBlue {
        didSet {
            
            let colorIndex = templateColor.rawValue
            
            //Clear previous checkmark
            _ = colorsStack.subviews.filter({ $0 is UIButton && $0.accessibilityLabel == "templateColor" })
                .map { _subView in
                    let button = _subView as! UIButton
                    button.setImage(nil, for: .normal)
                }
            
            for button in colorsStack.subviews where button is UIButton && button.tag == colorIndex {
                
                let _button = button as! UIButton
                
                _button.setImage(UIImage(systemName: "checkmark")?
                    .withRenderingMode(.alwaysOriginal)
                    .withTintColor(.white), for: .normal)
            }
            
            selectedItem["color"] = colorIndex
        }
    }
    
    lazy var _imagetype = ImageType.allCases.firstIndex(where: { $0 == imageType }) ?? 0
    lazy var _fontType = Fonts.allCases.firstIndex(where: { $0 == resumeFont }) ?? 1
    lazy var _format = ResumeSize.allCases.firstIndex(where: { $0 == resumeSize }) ?? 1
    lazy var _color = TemplatesColors.allCases.firstIndex(where: { $0 == templateColor }) ?? 0
    
    //MARK: - Selected Options
    lazy var selectedItem: [String: Int] = ["imageType": _imagetype, "fontType": _fontType, "format": _format, "color": _color, "template": selectedTemplate] {
        didSet {
            
            if let _selectedImageType = selectedItem["imageType"], let _imageType = ImageType(rawValue: _selectedImageType){
                imageType = _imageType
            }
            
            if let _selectedFont = selectedItem["fontType"], let _resumeFont = Fonts(rawValue: _selectedFont){
                resumeFont = _resumeFont
            }
            
            if let _selectedFormat = selectedItem["format"], let _resumeSize = ResumeSize(rawValue: _selectedFormat){
                resumeSize = _resumeSize
            }
            
            TemplatesGenerator(template: selectedTemplate,
                               imageType: imageType,
                               resumeFont: resumeFont,
                               resumeSize: resumeSize,
                               templateColor: templateColor,
                               resumeData: resumeTestData).build { [weak self] template, _, _ in
                
                guard let template = template else { return }
                
                let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeTemplate(_:)))
                let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeTemplate(_:)))
                leftSwipe.direction = .left
                rightSwipe.direction = .right
                
                template.addGestureRecognizer(leftSwipe)
                template.addGestureRecognizer(rightSwipe)
                
                for _view in contentView.subviews {
                    _view.removeFromSuperview()
                }
                
                contentView.addSubview(template)
                template.addSubview(chooseTemplateButton)
                
                let space = ceil(contentView.frame.height / 3)
                
                NSLayoutConstraint.activate([
                    template.topAnchor.constraint(equalTo: contentView.topAnchor),
                    template.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    template.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                    template.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1),
                    
                    chooseTemplateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    chooseTemplateButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: space)
                ])
                
            }
            let imageTypeAttributedText = NSMutableAttributedString(string: imageType.title, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any])
            imagetypeOptionMenu.setAttributedTitle(imageTypeAttributedText, for: .normal)
            
            let fontAttributedText = NSMutableAttributedString(string: resumeFont.title, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any])
            fontOptionMenu.setAttributedTitle(fontAttributedText, for: .normal)
            
            let formatAttributedText = NSMutableAttributedString(string: resumeSize.title, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any])
            formatOptionMenu.setAttributedTitle(formatAttributedText, for: .normal)
        }
    }
    
    
    //MARK: - Swicth templates
    
    //Swicth Summary Text
    lazy var previousTemplate: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Previous-Template")?.withTintColor(.apBrandyRose).withRenderingMode(.alwaysOriginal), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapPreviousTemplate), for: .touchUpInside)
        return button
    }()
    
    lazy var nextTemplate: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Next-Template")?.withTintColor(.apBrandyRose).withRenderingMode(.alwaysOriginal), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapNextTemplate), for: .touchUpInside)
        return button
    }()
    
    let templateLabelCounter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.attributedText = NSMutableAttributedString(string: "0 of 0", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 13) as Any, .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8) as Any ])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var switchTemplatesButtonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [previousTemplate, templateLabelCounter, nextTemplate])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.isHidden = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - ImageType
    let imageTypeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Image Type", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imagetypeOptionMenu: dropDownButton = {
        
        let selectedValue = selectedItem["imageType"]
        let title = ImageType(rawValue: selectedValue ?? 0)?.title ?? "Square"
        
        let button = dropDownButton(title: title, textColor: .apTintColor, fontAlpha: 1, contentAlignment: .trailing)
        button.addTarget(self, action: #selector(didSelectImageType), for: .touchUpInside)
        return button
    }()
    
    lazy var imageTypeStack: UIStackView = {
        let _stack = UIStackView(arrangedSubviews: [imageTypeLabel, imagetypeOptionMenu])
        _stack.axis = .horizontal
        _stack.translatesAutoresizingMaskIntoConstraints = false
        return _stack
    }()
    
    //MARK: - Font-Type
    
    let fontTypeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Font Type",
                                                  attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var fontOptionMenu: dropDownButton = {
        
        let selectedValue = selectedItem["fontType"] ?? 3
        let title = Fonts(rawValue: selectedValue)?.title ?? "CenturyGothic"
        
        let button = dropDownButton(title: title, textColor: .apTintColor, fontAlpha: 1, contentAlignment: .trailing)
        button.addTarget(self, action: #selector(didSelectFontType), for: .touchUpInside)
        return button
    }()
    
    lazy var fontTypeStack: UIStackView = {
        let _stack = UIStackView(arrangedSubviews: [fontTypeLabel, fontOptionMenu])
        _stack.axis = .horizontal
        _stack.translatesAutoresizingMaskIntoConstraints = false
        return _stack
    }()
    
    
    //MARK: - Format
    let formatLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Format",
                                                  attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var formatOptionMenu: dropDownButton = {
        
        let selectedValue = selectedItem["format"]
        let title = ResumeSize(rawValue: selectedValue ?? 1)?.title ?? "US Letter"
        
        let button = dropDownButton(title: title, textColor: .red, fontAlpha: 1, contentAlignment: .trailing)
        button.addTarget(self, action: #selector(didSelectformat), for: .touchUpInside)
        return button
    }()
    
    lazy var formatStack: UIStackView = {
        let _stack = UIStackView(arrangedSubviews: [formatLabel, formatOptionMenu])
        _stack.axis = .horizontal
        _stack.translatesAutoresizingMaskIntoConstraints = false
        return _stack
    }()
    
    
    //MARK: - UIPickerView
    lazy var tempTextView = UITextField(frame: .zero)
    lazy var tempTextView2 = UITextField(frame: .zero)
    lazy var tempTextView3 = UITextField(frame: .zero)
    
    lazy var _imageTypePickerView = UIDataPicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160))
    lazy var _fontTypePickerView = UIDataPicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
    lazy var _formatPickerView = UIDataPicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160))
    
    lazy var doneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        toolbar.backgroundColor = .apBackground
        
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
        tempTextView3.resignFirstResponder()
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem){
        closeButtonTapped()
    }
    
    @objc func didSelectImageType(){
        self.tempTextView.becomeFirstResponder()
        
        var _index = 1
        if let _selectedValueindex = selectedItem["imageType"] {
            _index = _selectedValueindex
        }
        
        self._imageTypePickerView.selectRow(_index, inComponent: 0, animated: true)
    }
    
    
    @objc func didSelectFontType(){
        self.tempTextView2.becomeFirstResponder()
        
        var _index = 3
        if let _selectedValueindex = selectedItem["fontType"] {
            _index = _selectedValueindex
        }
        
        self._fontTypePickerView.selectRow(_index, inComponent: 0, animated: true)
    }
    
    @objc func didSelectformat(){
        self.tempTextView3.becomeFirstResponder()
        
        var _index = 1
        if let _selectedValueindex = selectedItem["format"] {
            _index = _selectedValueindex
        }
        
        self._formatPickerView.selectRow(_index, inComponent: 0, animated: true)
    }
    
    
    func setupPickers(){
        
        view.addSubview(tempTextView)
        view.addSubview(tempTextView2)
        view.addSubview(tempTextView3)
        
        tempTextView.inputView = _imageTypePickerView
        tempTextView.inputAccessoryView = doneToolbar
        
        tempTextView2.inputView = _fontTypePickerView
        tempTextView2.inputAccessoryView = doneToolbar
        
        tempTextView3.inputView = _formatPickerView
        tempTextView3.inputAccessoryView = doneToolbar
        
        _imageTypePickerView.dataSource = self
        _fontTypePickerView.dataSource = self
        _formatPickerView.dataSource = self
        
        _imageTypePickerView.delegate = self
        _fontTypePickerView.delegate = self
        _formatPickerView.delegate = self
        
        _imageTypePickerView.tag = 1
        _fontTypePickerView.tag = 2
        _formatPickerView.tag = 3
        
    }
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var globalContentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle == .light {
            templateColor = .RegalBlue
        }else{
            templateColor = .CuttySark
        }
    }
    
    //MARK: - init Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .apBackground
        navigationItem.title = ""
    
        //MARK: - Fix Scroll Template
        view.addSubview(scrollView)
        scrollView.addSubview(globalContentView)
        
        let bottomAnchor = globalContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        bottomAnchor.priority = UILayoutPriority(250)
        
        let centerYAnchor = globalContentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        centerYAnchor.priority = UILayoutPriority(250)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            globalContentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            globalContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            globalContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            
            globalContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            centerYAnchor,
            bottomAnchor,
        ])
        
        globalContentView.addSubview(closeButton)
        globalContentView.addSubview(topTextPresentation)
        globalContentView.addSubview(contentView)
        globalContentView.addSubview(switchTemplatesButtonsStack)
        
        globalContentView.addSubview(colorsStack)
        
        resumeTestData = ResumeData( sections: [], stacks: []).buildDataPlaceHolder()
        
        //Menu Labels
        globalContentView.addSubview(imageTypeStack)
        globalContentView.addSubview(fontTypeStack)
        globalContentView.addSubview(formatStack)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: globalContentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: globalContentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(lessThanOrEqualToConstant: 24),

            //Top-Text
            topTextPresentation.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            topTextPresentation.centerXAnchor.constraint(equalTo: globalContentView.centerXAnchor),
            topTextPresentation.widthAnchor.constraint(equalTo: globalContentView.widthAnchor, multiplier: 0.98),
            topTextPresentation.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
            
            //Content-View
            contentView.topAnchor.constraint(equalTo: topTextPresentation.bottomAnchor, constant: 10),
            contentView.centerXAnchor.constraint(equalTo: globalContentView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: globalContentView.widthAnchor, multiplier: 0.8),
            contentView.heightAnchor.constraint(equalTo: globalContentView.heightAnchor, multiplier: 0.58),
            
            //Switch Templates
            switchTemplatesButtonsStack.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            switchTemplatesButtonsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            switchTemplatesButtonsStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            switchTemplatesButtonsStack.heightAnchor.constraint(lessThanOrEqualToConstant: 30),

            //Colors StackView
            colorsStack.topAnchor.constraint(equalTo: switchTemplatesButtonsStack.bottomAnchor, constant: 15),
            colorsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorsStack.heightAnchor.constraint(lessThanOrEqualToConstant: 50),

            //imageTypeStack
            imageTypeStack.topAnchor.constraint(equalTo: colorsStack.bottomAnchor, constant: 20),
            imageTypeStack.centerXAnchor.constraint(equalTo: colorsStack.centerXAnchor),
            imageTypeStack.widthAnchor.constraint(equalTo: colorsStack.widthAnchor, multiplier: 0.9),
            imageTypeStack.heightAnchor.constraint(lessThanOrEqualToConstant: 25),
            
            
            //fontTypeStack
            fontTypeStack.topAnchor.constraint(equalTo: imageTypeStack.bottomAnchor, constant: 20),
            fontTypeStack.centerXAnchor.constraint(equalTo: imageTypeStack.centerXAnchor),
            fontTypeStack.widthAnchor.constraint(equalTo: imageTypeStack.widthAnchor, multiplier: 1),
            fontTypeStack.heightAnchor.constraint(lessThanOrEqualToConstant: 25),

            
            //fontTypeStack
            formatStack.topAnchor.constraint(equalTo: fontTypeStack.bottomAnchor, constant: 20),
            formatStack.centerXAnchor.constraint(equalTo: fontTypeStack.centerXAnchor),
            formatStack.widthAnchor.constraint(equalTo: imageTypeStack.widthAnchor, multiplier: 1),
            formatStack.heightAnchor.constraint(lessThanOrEqualToConstant: 25),

            formatStack.bottomAnchor.constraint(equalTo: globalContentView.safeAreaLayoutGuide.bottomAnchor, constant: -20)

            
        ])
        
        setupPickers()
        
        TemplatesGenerator(template: selectedTemplate,
                           imageType: imageType,
                           resumeFont: resumeFont,
                           resumeSize: resumeSize,
                           templateColor: templateColor,
                           resumeData: resumeTestData).build { [weak self] template, _, _ in
            
            guard let template = template else { return }
            
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeTemplate(_:)))
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeTemplate(_:)))
            leftSwipe.direction = .left
            rightSwipe.direction = .right
            
            template.addGestureRecognizer(leftSwipe)
            template.addGestureRecognizer(rightSwipe)
            
            for _view in contentView.subviews {
                _view.removeFromSuperview()
            }
            
            contentView.addSubview(template)
            template.addSubview(chooseTemplateButton)

            NSLayoutConstraint.activate([
                template.topAnchor.constraint(equalTo: contentView.topAnchor),
                template.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                template.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                template.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1),

                chooseTemplateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ])
            
        }
        
        chooseTemplateButtonConstraint = chooseTemplateButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        chooseTemplateButtonConstraint.isActive = true
        
        updateCounterLabel(selected: 0, count: templatesList)
        
    }
    
    var chooseTemplateButtonConstraint: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let space = ceil(contentView.frame.height / 3)
        chooseTemplateButtonConstraint.constant = space

    }
    
}
