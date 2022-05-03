//
//  SummaryVC.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 26/1/2022.
//

import UIKit
import CoreData


class SummaryVC: UIViewController, initialObjectDataSource {
    
    var presentingMainSection: Bool?
    var objectId: NSManagedObjectID?
    
    var initialObject: Initial?{
        didSet{
            if let summary = initialObject?.summary?.allObjects.first as? Summary {
                objectId = summary.objectID
                
                if let text = summary.text {
                    summaryTextView.attributedText = colorizedSubString(initText: text)
                    textViewDidChange(summaryTextView)
                }
                
            }
        }
    }
    
    var summariesPresenter = SummariesPresenter()
    var summaries: [String] = []
    
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
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.backgroundColor = .apTintColor.withAlphaComponent(0.4)
        activityIndicator.style = .medium
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.layer.cornerRadius = 8
        activityIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
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
        
        let icon = NSTextAttachment()
        icon.image = UIImage(named: "summary")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
        let attachement = NSAttributedString(attachment: icon)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(attachement)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: "Summary", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 18) as Any, .foregroundColor : UIColor.apTintColor as Any]))
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "Your summary shows employers you’re right for their job.", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //
    lazy var searchSummaryTexField: AutocompleteField = {
        let textField = AutocompleteField()
        
        textField.placeholder = "Application Developer..."
        textField.autocorrectionType = .no
        textField.font = UIFont(name: Theme.nunitoSansRegular, size: 14)
        textField.borderStyle = .roundedRect
        
        textField.delegate = self
        textField.tag = 0
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.backgroundColor = .apBackground
        textField.textColor = .apTintColor
        textField.tintColor = .apTintColor
        
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 0.8
        textField.layer.borderColor = UIColor.apBorderJobCell.cgColor
        
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.returnKeyType = .continue
        textField.keyboardType = .alphabet
        
        if let image = UIImage(named: "search")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal) {
            textField.setLeftView(image: image)
            textField.leftViewPadding = 30
        }
        
        textField.autocapitalizationType = .words
        textField.suggestions = jobSuggestions
        
        return textField
    }()
    
    
    lazy var searchBottomLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Showing results for", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
        
        attributedText.append(NSAttributedString(string: "`Application Developer`", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any, .foregroundColor : UIColor.saltBox as Any]))
        
        label.isHidden = true
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var searchCountBottomLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Found 0 results", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 11) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var labelPlaceholder: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.attributedText = NSMutableAttributedString(string: "Type your summary here", attributes: [.font : UIFont(name: Theme.nunitoSansItalic, size: 14) as Any, .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8) as Any ])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var summaryTextView: UITextView = {
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
        textView.returnKeyType = .done
        
        textView.smartDashesType = .yes
        textView.delegate = self
        
        textView.addSubview(labelPlaceholder)
        labelPlaceholder.topAnchor.constraint(equalTo: textView.topAnchor, constant: 6).isActive = true
        labelPlaceholder.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5).isActive = true
        labelPlaceholder.widthAnchor.constraint(equalTo: textView.widthAnchor, multiplier: 0.95).isActive = true
        
        return textView
    }()
    
    
    //Swicth Summary Text
    lazy var previousSummary: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Previous-Template")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapPreviousSummary), for: .touchUpInside)
        return button
    }()
    
    lazy var nextSummary: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Next-Template")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapNextSummary), for: .touchUpInside)
        return button
    }()
    
    let labelCounter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.attributedText = NSMutableAttributedString(string: "0 of 0", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 13) as Any, .foregroundColor : UIColor.apTintColorLight as Any ])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var switchSummaryButtonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [previousSummary, labelCounter, nextSummary])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.isHidden = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Final Buttons
    
    lazy var continueButton: UIButton = {
        var button = UIButton(type: .system)
        let imgsz = UIImageView()
        imgsz.accessibilityLabel = "ContinueButtonImage"
        imgsz.image = UIImage(named: "arrow-right")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        imgsz.contentMode = .scaleAspectFit
        imgsz.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "Save & Continue", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any, .foregroundColor : UIColor.white as Any ])
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
        
        let attributedText = NSMutableAttributedString(string: "Back", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8) as Any])
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = .white
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
        
        continueButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        backButton.backgroundColor = .apBackground
        backButton.layer.borderColor = UIColor.apBorderJobCell.cgColor
        
        summaryTextView.layer.borderColor = UIColor.apBorderJobCell.cgColor
//        summaryTextView.textColor = .apTintColor
//        summaryTextView.tintColor = .apTintColor
        
        searchSummaryTexField.layer.borderColor = UIColor.apBorderJobCell.cgColor

    }
    
    var summaryTopAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        backButton.backgroundColor = .apBackground
        backButton.layer.borderColor = UIColor.apBorderJobCell.cgColor
        
        summariesPresenter.delegate = self
        
        view.backgroundColor = .apBackground
        
        //Hide keyboard after Edit
        view.hideKeyboard()
        
        //Init-Subviews
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
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
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            bottomAnchor,
            centerYAnchor,
        ])
        
        contentView.addSubview(previousVCButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(sloganLabel)
        
        contentView.addSubview(searchSummaryTexField)
        contentView.addSubview(searchBottomLabel)
        contentView.addSubview(searchCountBottomLabel)
        contentView.addSubview(summaryTextView)
        contentView.addSubview(switchSummaryButtonsStack)
        
        contentView.addSubview(buttonsStack)
        
        summaryTopAnchor = summaryTextView.topAnchor.constraint(equalTo: searchCountBottomLabel.bottomAnchor, constant: -10)
        summaryTopAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            previousVCButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            previousVCButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: previousVCButton.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: previousVCButton.leadingAnchor, constant: 0),
            
            sloganLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            sloganLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            sloganLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            sloganLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            
            searchSummaryTexField.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 30),
            searchSummaryTexField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            searchSummaryTexField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            
            searchBottomLabel.topAnchor.constraint(equalTo: searchSummaryTexField.bottomAnchor, constant: 10),
            searchBottomLabel.leadingAnchor.constraint(equalTo: searchSummaryTexField.leadingAnchor),
            
            searchCountBottomLabel.topAnchor.constraint(equalTo: searchBottomLabel.bottomAnchor),
            searchCountBottomLabel.leadingAnchor.constraint(equalTo: searchBottomLabel.leadingAnchor),
            
            summaryTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            summaryTextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            summaryTextView.heightAnchor.constraint(equalToConstant: 300),
            
            switchSummaryButtonsStack.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 20),
            switchSummaryButtonsStack.leadingAnchor.constraint(equalTo: summaryTextView.leadingAnchor),
            switchSummaryButtonsStack.trailingAnchor.constraint(equalTo: summaryTextView.trailingAnchor),
            
            buttonsStack.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: switchSummaryButtonsStack.bottomAnchor, multiplier: 7.5),
            buttonsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonsStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
        ])
        
    }
    
    var summaryIndex: Int = 0
    
    @objc func didTapNextSummary(){
        
        if self.summaries.count == 0 {
            return
        }
        
        if summaryIndex == self.summaries.count-1 {
            summaryIndex = 0
        }else{
            summaryIndex += 1
        }
        
        let initText = self.summaries[summaryIndex]
        
        DispatchQueue.main.async { [weak self] in
            if let summary = self?.summaryTextView {
                self?.summaryTextView.attributedText = colorizedSubString(initText: initText)
                self?.textViewDidChange(summary)

                if let index = self?.summaryIndex, let ofIndex = self?.summaries.count {
                    self?.switchSummaryButtonsStack.isHidden = false
                    self?.labelCounter.attributedText = NSMutableAttributedString(string: "\(index+1) of \(ofIndex)", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 13) as Any, .foregroundColor: UIColor.apTintColorLight as Any ])
                }
            }
        }
    }
    
    @objc func didTapPreviousSummary(){
        
        if self.summaries.count == 0 {
            return
        }
        
        if summaryIndex == 0 {
            summaryIndex = self.summaries.count-1
        }else{
            summaryIndex -= 1
        }
        
        let initText = self.summaries[summaryIndex]
        
        DispatchQueue.main.async { [weak self] in
            if let summary = self?.summaryTextView {
                self?.summaryTextView.attributedText = colorizedSubString(initText: initText)
                self?.textViewDidChange(summary)
                
                if let index = self?.summaryIndex, let ofIndex = self?.summaries.count {
                    self?.switchSummaryButtonsStack.isHidden = false
                    self?.labelCounter.attributedText = NSMutableAttributedString(string: "\(index+1) of \(ofIndex)", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 13) as Any, .foregroundColor: UIColor.apTintColorLight as Any ])
                }
            }
        }
    }
    
    @objc func didTapContinue(){
        if let summaryText = summaryTextView.text {
            
            let summaryModel = SummaryModel(initialObject: initialObject, objectId: objectId, text: summaryText)
            
            CoreDataManager.shared.setupSummary(options: summaryModel) { [weak self] _ in
                self?.didTapPrevious()
            }
        }
    }
    
    @objc func didTapPrevious(){
        if let target = popTo(MainSectionVC.self), target == false {
            let _initVC = MainSectionVC()
            _initVC.initialObject = initialObject
            self.navigationController?.pushViewController(_initVC, animated: true)
        }
    }
    
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
    
}


extension SummaryVC: SummariesPresenterProtocol {
    
    func presentSummary(summaries: [String], keyword: String?) {
        
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.summaryTextView.isUserInteractionEnabled = true
            self?.searchSummaryTexField.isEnabled = true
            
            //Fix top space before summary
            self?.searchBottomLabel.isHidden = false
            self?.summaryTopAnchor.constant = 20
        }
        
        self.summaries = summaries
        let _count = summaries.count
        
        DispatchQueue.main.async { [weak self] in
            self?.searchCountBottomLabel.isHidden = false
            self?.searchCountBottomLabel.attributedText = NSMutableAttributedString(string: "Found \(_count) results", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 11) as Any, .foregroundColor: UIColor.apTintColor as Any])
            
            //Bottom Stack Buttons
            if _count > 0 {
                self?.switchSummaryButtonsStack.isHidden = false
            }else{
                self?.switchSummaryButtonsStack.isHidden = true
            }
            
            self?.labelCounter.attributedText = NSMutableAttributedString(string: "\(_count == 0 ? _count : 1) of \(_count)", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 13) as Any, .foregroundColor: UIColor.apTintColorLight as Any ])
            
            //Set first summary
            if let summary = self?.summaryTextView {
                self?.summaryTextView.attributedText = colorizedSubString(initText: _count > 0 ? summaries[0] : "")
                self?.textViewDidChange(summary)
            }
            
            if let keyword = keyword {
                self?.searchSummaryTexField.text = keyword
                
                let attributedText = NSMutableAttributedString(string: "Showing results for", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
                attributedText.append(NSAttributedString(string: "`\(keyword.firstCapitalized)`", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any]))
                
                self?.searchBottomLabel.attributedText = attributedText
            }
        }
    }
    
    func presentWaitStatus() {
        activityIndicator.startAnimating()
        summaryTextView.isUserInteractionEnabled = false
        searchSummaryTexField.isEnabled = false
    }
}

extension SummaryVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let textField = textField as! AutocompleteField
        textField.text = textField.suggestion
        
        tagBasedTextField(textField) {
            let keyword = searchSummaryTexField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            summariesPresenter.fetchSummaries(keyword: keyword)
        }
        return false
    }
    
    private func tagBasedTextField(_ textField: UITextField, done: ()->() ) {
        let nextTextFieldTag = textField.tag + 1
        
        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            done()
        }
    }
}


extension SummaryVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        //Placeholder
        
        //
        summaryTextView.layer.borderColor = UIColor.apBorderJobCell.cgColor
//        summaryTextView.textColor = .apTintColor
//        summaryTextView.tintColor = .apTintColor
        //
        
        let newAlpha: CGFloat = textView.text.isEmpty ? 1 : 0
        if labelPlaceholder.alpha != newAlpha {
            UIView.animate(withDuration: 0.2) {
                self.labelPlaceholder.alpha = newAlpha
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
