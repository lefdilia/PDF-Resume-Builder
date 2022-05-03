//
//  CertificationsVC.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 3/2/2022.
//

import UIKit



class CertificationsVC: UIViewController, initialObjectDataSource {
    
    weak var initialObject: Initial?
    var presentingMainSection: Bool?
    
    var certificationsPresenter = CertificationsPresenter()
    var certifications: [Certifications] = []
    
    //MARK: - Previous Button
    lazy var previousVCButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back-arrow")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        let icon = NSTextAttachment()
        icon.image = UIImage(named: "certifications")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
        let attachement = NSAttributedString(attachment: icon)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(attachement)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: "Certifications", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 18) as Any, .foregroundColor : UIColor.apTintColor as Any]))
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "Do you hold any certifications? Include them, they show you’re serious about your career growth.", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - TableView
    lazy var certificationsTableView: UITableView = {
        let table = UITableView()
        table.register(certificationsTableViewCell.self, forCellReuseIdentifier: certificationsTableViewCell.cellId)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .singleLine
        table.backgroundColor = .apBackground
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isUserInteractionEnabled = true
        table.allowsSelection = false
        table.allowsSelectionDuringEditing = false
        return table
    }()
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        backButton.backgroundColor = .apBackground
        backButton.layer.borderColor = UIColor.apBorderJobCell.cgColor
        
        if #available(iOS 15.0, *) {
            
            var config = UIButton.Configuration.plain()
            config.imagePadding = 3
            config.image = UIImage(named: "add-section-circle")?.imageWithSize(CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal)
            var container = AttributeContainer()
            container.font = UIFont(name: Theme.nunitoSansBold, size: 14)
            container.foregroundColor = UIColor.apAddLabel
            container.underlineStyle = .single
            config.attributedTitle = AttributedString("Add Certification", attributes: container)
            addCertificationButton.configuration = config
            
        }else{
            
            let icon = NSTextAttachment()
            icon.image = UIImage(named: "add-section-circle")?.imageWithSize(CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal)
            icon.bounds = CGRect(x: 0, y: -4, width: icon.image!.size.width, height: icon.image!.size.width )
            
            let attachement = NSAttributedString(attachment: icon)
            let attributedText = NSMutableAttributedString(string: "")
            attributedText.append(attachement)
            attributedText.append(NSAttributedString(string: " "))
            
            attributedText.append(NSAttributedString(string: "Add Certification", attributes: [
                .font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any,
                .foregroundColor : UIColor.apAddLabel as Any,
                .underlineStyle : NSUnderlineStyle.single.rawValue
            ]))
            
            addCertificationButton.setAttributedTitle(attributedText, for: .normal)
        }
    }
    
    lazy var addCertificationButton: UIButton = {
        
        let button = UIButton(type: .system)

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 3
            config.image = UIImage(named: "add-section-circle")?.imageWithSize(CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal)
            var container = AttributeContainer()
            container.font = UIFont(name: Theme.nunitoSansBold, size: 14)
            container.foregroundColor = .apAddLabel
            container.underlineStyle = .single
            config.attributedTitle = AttributedString("Add Certification", attributes: container)
            button.configuration = config
            
        }else{
            
            let icon = NSTextAttachment()
            icon.image = UIImage(named: "add-section-circle")?.imageWithSize(CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal)
            icon.bounds = CGRect(x: 0, y: -4, width: icon.image!.size.width, height: icon.image!.size.width )
            
            let attachement = NSAttributedString(attachment: icon)
            let attributedText = NSMutableAttributedString(string: "")
            attributedText.append(attachement)
            attributedText.append(NSAttributedString(string: " "))
        
            attributedText.append(NSAttributedString(string: "Add Certification", attributes: [
                .font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any,
                .foregroundColor : UIColor.apAddLabel as Any,
                .underlineStyle : NSUnderlineStyle.single.rawValue
            ]))
            
            button.setAttributedTitle(attributedText, for: .normal)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCertification), for: .touchUpInside)
        return button
    }()
    
    @objc func addCertification(){
        
        let parsedForm = parseForm()
        if parsedForm.filter({ $0.trimmingCharacters(in: .whitespacesAndNewlines) == "" }).count > 0 {
            return
        }
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let nElement = Certifications(context: context)
        nElement.title = ""
        nElement.status = true
        nElement.date = Date()
        nElement.orderIndex = Int16(self.certifications.count+1)
        nElement.initialObject = initialObject
        
        if context.hasChanges {
            _ = formDataModel()
            try? context.save()
        }
        
        self.certifications.append(nElement)
        
        let row = IndexPath(row: self.certifications.count - 1, section: 0)
        
        self.certificationsTableView.insertRows(at: [row],with: .automatic)
        self.certificationsTableView.scrollToRow(at:row, at: .top, animated: true)
        
        if let cell = certificationsTableView.cellForRow(at: row) as? certificationsTableViewCell {
            
            if let textField = cell.contentView.subviews.filter({$0 is UITextField }).first as? customFormField {
                textField.becomeFirstResponder()
            }
        }
    }
    
    private func formDataModel() -> [Certifications]{
        
        let _context = CoreDataManager.shared.persistentContainer.viewContext
        
        for (_, sView) in certificationsTableView.subviews.enumerated() where sView is UITableViewCell && sView.isHidden == false {
            let cell = sView as! certificationsTableViewCell
            let neededSubviews = cell.subviews.first?.subviews.map({$0})
            
            let objectID = cell.objectId
            let certification = self.certifications.first(where: { $0.objectID == objectID })
            
            if let textField = neededSubviews?.filter({$0 is UITextField }).first as? customFormField {
                if let _text = textField.text {
                    let title = _text.replacingOccurrences(of: "^\\s+|\\s+$", with: "", options: .regularExpression, range: nil)
                    if title.isEmpty, let objectID = objectID {
                        let object = _context.object(with: objectID)
                        _context.delete(object)
                        continue
                    }
                    certification?.title = title
                }
            }
            
            var rangedDate: [String] = []
            if let yearMenu = neededSubviews?.filter({ $0 is UIButton && $0.accessibilityLabel == "year-dropdown" }).first as? dropDownButton {
                if let year = yearMenu.titleLabel?.text {
                    rangedDate.append(year)
                }
            }
            
            if let monthMenu = neededSubviews?.filter({ $0 is UIButton && $0.accessibilityLabel == "month-dropdown" }).first as? dropDownButton {
                if let month = monthMenu.titleLabel?.text, let numericMonth = _months.firstIndex(of: month) {
                    rangedDate.append(String(format: "%02d", numericMonth+1))
                }
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let certificateDate = formatter.date(from: rangedDate.joined(separator: "-")) ?? Date()
            
            certification?.date = certificateDate
            
        }
        
        return self.certifications
    }
    
    //MARK: - PickerView
    
    let _months: [String] = DateFormatter().monthSymbols.map({ $0.capitalized })
    
    let _currentYear = Calendar.current.component(.year, from: Date())
    lazy var _years = (1900..._currentYear).map { String($0) }
    
    lazy var selectedItem: [String: String] = [:]
    
    lazy var tempTextView = UITextField(frame: .zero)
    lazy var _monthsPickerView = UIDataPicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
    
    lazy var tempTextView2 = UITextField(frame: .zero)
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
    
    var didSelectDone: ((Int, String,String)->())?
    
    @objc func doneButtonTapped(sender: UIBarButtonItem){
        
        if tempTextView.isFirstResponder {
            
            let targetCell = tempTextView.tag
            
            let indexRow = self._monthsPickerView.selectedRow(inComponent: 0)
            let selectedMonth = _months[indexRow]
            didSelectDone?(targetCell, "month-dropdown", selectedMonth)
        }
        
        if tempTextView2.isFirstResponder {
            let targetCell = tempTextView2.tag
            
            let indexRow = self._yearPickerView.selectedRow(inComponent: 0)
            let selectedYear = _years[indexRow]
            didSelectDone?(targetCell, "year-dropdown", selectedYear)
        }
    }
    
    @objc func closeButtonTapped(){
        tempTextView.resignFirstResponder()
        tempTextView2.resignFirstResponder()
    }
    
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
        var button = UIButton(type: .system)
        
        let attributedText = NSMutableAttributedString(string: "Back", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8) as Any])
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = .apBackground
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.apBorderJobCell.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    
    let buttonsStack: UIView = {
        let _view = UIView()
        return _view
    }()
    
    @objc func didTapContinue(){
        _ = formDataModel()
        
        CoreDataManager.shared.setupCertifications { [weak self] _ in
            self?.didTapBackButton()
        }
    }
    
    @objc func didTapBackButton(){
        if let target = popTo(MainSectionVC.self), target == false {
            let _initVC = MainSectionVC()
            _initVC.initialObject = initialObject
            self.navigationController?.pushViewController(_initVC, animated: true)
        }
    }
    
    
    private func parseForm() -> [String] {
        
        var certificationsDict = [String]()
        
        //Clear Hidden Subviews
        for (_, sView) in certificationsTableView.subviews.enumerated() where sView is UITableViewCell && sView.isHidden == false {
            
            let neededSubviews = sView.subviews.first?.subviews.map({$0})
            
            if let textField = neededSubviews?.filter({$0 is UITextField }).first as? customFormField {
                if let _text = textField.text {
                    certificationsDict.append(_text)
                }
            }
        }
        return certificationsDict
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        certificationsTableView.contentInset = contentInsets
        certificationsTableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        // reset back the content inset to zero after keyboard is gone
        certificationsTableView.contentInset = contentInsets
        certificationsTableView.scrollIndicatorInsets = contentInsets
    }
    
    
    @objc func didTapPrevious(){
        _ = formDataModel()
        
        if let target = popTo(MainSectionVC.self), target == false {
            let _initVC = MainSectionVC()
            _initVC.initialObject = initialObject
            self.navigationController?.pushViewController(_initVC, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        certificationsPresenter.delegate = self
        certificationsPresenter.fetchCertificationsList(initialObject: initialObject)
        
        view.backgroundColor = .apBackground
        
        if presentingMainSection == true && initialObject?.status == true {
            //Update
            let attributedText = NSMutableAttributedString(string: "Update", attributes: [
                .font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any,
                .foregroundColor: UIColor.white as Any])
            continueButton.backgroundColor = .apContinueButton
            continueButton.setAttributedTitle(attributedText, for: .normal)
            
            let cancelAttributedText = NSMutableAttributedString(string: "Back", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8) as Any])
            backButton.setAttributedTitle(cancelAttributedText, for: .normal)
        }
        
        view.hideKeyboard()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(previousVCButton)
        view.addSubview(titleLabel)
        view.addSubview(sloganLabel)
        
        NSLayoutConstraint.activate([
            previousVCButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            previousVCButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: previousVCButton.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: previousVCButton.leadingAnchor, constant: 0),
            
            sloganLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            sloganLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            sloganLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 15),
            sloganLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
        
        view.addSubview(certificationsTableView)
        
        NSLayoutConstraint.activate([
            certificationsTableView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 15),
            certificationsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            certificationsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            certificationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        //
        
        //Month PickerView
        tempTextView.inputView = _monthsPickerView
        tempTextView.inputAccessoryView = doneToolbar
        _monthsPickerView.dataSource = self
        _monthsPickerView.delegate = self
        _monthsPickerView.tag = 1
        
        //Year PickerView
        tempTextView2.inputView = _yearPickerView
        tempTextView2.inputAccessoryView = doneToolbar
        _yearPickerView.dataSource = self
        _yearPickerView.delegate = self
        _yearPickerView.tag = 2
        
        
        view.addSubview(tempTextView)
        view.addSubview(tempTextView2)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: - Table Footer View
        certificationsTableView.tableFooterView = buttonsStack
        certificationsTableView.tableFooterView?.frame.size.height = 160
        
        buttonsStack.addSubview(addCertificationButton)
        buttonsStack.addSubview(backButton)
        buttonsStack.addSubview(continueButton)
        
        
        NSLayoutConstraint.activate([
            
            backButton.centerYAnchor.constraint(equalTo: buttonsStack.centerYAnchor, constant: 20),
            backButton.centerXAnchor.constraint(equalTo: buttonsStack.centerXAnchor, constant: -80),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 150),
            
            continueButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
            continueButton.widthAnchor.constraint(equalToConstant: 150),
            continueButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10),
            
            addCertificationButton.topAnchor.constraint(equalTo: buttonsStack.topAnchor, constant: 20),
            addCertificationButton.trailingAnchor.constraint(equalTo: buttonsStack.trailingAnchor, constant: -5),
        ])
        
        //Update Constraints
        certificationsTableView.layoutIfNeeded()
    }
    
    
}

extension CertificationsVC: CertificationsPresenterDelegate {
    
    func presentCertifications(list: [Certifications]) {
        self.certifications = list
        
        if list.count == 0 {
            self.addCertification()
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.certificationsTableView.reloadData()
        }
    }
}


extension CertificationsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, completion) in
            
            if let certification = self?.certifications[indexPath.row] {
                
                self?.certifications.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // Clear subviews
                _ = tableView.subviews.enumerated()
                    .filter({ $1 is UITableViewCell && $1.alpha == 0 })
                    .map({$1.removeFromSuperview()})
                
                CoreDataManager.shared.removeObject(objectId: certification.objectID) { _ in
                    completion(true)
                }
            }
        }
        
        deleteAction.backgroundColor = .white
        deleteAction.image = UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(scale: .small))?.withTintColor(.appleBlossom).withRenderingMode(.alwaysOriginal)
        
        let swipes = UISwipeActionsConfiguration(actions: [deleteAction])
        swipes.performsFirstActionWithFullSwipe = false
        
        return swipes
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.certifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: certificationsTableViewCell.cellId, for: indexPath) as! certificationsTableViewCell
        
        let certification = self.certifications[indexPath.row]
        
        cell.certification = certification
        cell.tag = indexPath.row
        cell.objectId = certification.objectID
        
        cell.keyboardReturnTapped = { [weak self] in
            let parsedForm = self?.parseForm()
            if let parsed_ = parsedForm?.filter({ $0.trimmingCharacters(in: .whitespacesAndNewlines) == "" }), parsed_.count > 0 {
                return
            }
            self?.addCertification()
        }
        
        self.didSelectDone = { [weak self] cellTag, accessibilityLabel, selection in
            
            if accessibilityLabel == "month-dropdown" {
                let attributedText = NSMutableAttributedString(string: selection, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 15) as Any, .foregroundColor: UIColor.apTintColor ])
                
                let monthDropDown = self?.updateDropDownMenu(tag: cellTag, accessibilityLabel: .month)
                monthDropDown?.setAttributedTitle(attributedText, for: .normal)
                
            }
            
            if accessibilityLabel == "year-dropdown" {
                let attributedText = NSMutableAttributedString(string: selection, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor ])
                
                let yearDropDown = self?.updateDropDownMenu(tag: cellTag, accessibilityLabel: .year)
                yearDropDown?.setAttributedTitle(attributedText, for: .normal)
            }
            
            self?.closeButtonTapped()
        }
        
        cell.didSelectMonthTapped = { button in
            self.tempTextView.tag = button.tag
            self.tempTextView.becomeFirstResponder()
            
            //update exsited value on pickerView
            let cellTag = button.tag
            _ = self.updateDropDownMenu(tag: cellTag, accessibilityLabel: .month)
        }
        
        cell.didSelectYearTapped = { button in
            self.tempTextView2.tag = button.tag
            self.tempTextView2.becomeFirstResponder()
            
            let cellTag = button.tag
            _ = self.updateDropDownMenu(tag: cellTag, accessibilityLabel: .year)
        }
        
        return cell
    }
    
    private func updateDropDownMenu(tag cellTag: Int, accessibilityLabel: CertificationsAccessibilityLabel) -> dropDownButton?{
        
        for (_, sView) in self.certificationsTableView.subviews.enumerated() where sView is UITableViewCell && sView.isHidden == false && sView.tag == cellTag {
            
            let neededSubviews = sView.subviews.first?.subviews.map({$0})
            
            if let dropDownMenu = neededSubviews?.filter({ $0 is UIButton && $0.accessibilityLabel == accessibilityLabel.description }).first as? dropDownButton {
                
                
                if tempTextView.isFirstResponder { //Month
                    var _index = 0
                    
                    let dropDownLabel = dropDownMenu.titleLabel?.text ?? "February"
                    let title = dropDownLabel == "Month" ? "February" : dropDownLabel
                    
                    if let _selectedValueindex = _months.firstIndex(of: title) {
                        _index = _selectedValueindex
                    }
                    
                    self._monthsPickerView.selectRow(_index, inComponent: 0, animated: true)
                }
                
                if tempTextView2.isFirstResponder { //Year
                    var _index = 0
                    
                    let titleLabel = dropDownMenu.titleLabel?.text ?? "\(_currentYear)"
                    let title = titleLabel == "Year" ? "\(_currentYear-4)" : titleLabel
                    
                    if let _selectedValueindex = _years.firstIndex(of: title) {
                        _index = _selectedValueindex
                    }
                    
                    self._yearPickerView.selectRow(_index, inComponent: 0, animated: true)
                }
                
                
                return dropDownMenu
                
            }
        }
        return nil
    }
    
}

