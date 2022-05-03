//
//  SoftwaresVC.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 4/2/2022.
//

import UIKit
import CoreData


class SoftwaresVC: UIViewController, initialObjectDataSource {
    
    weak var initialObject: Initial?
    var presentingMainSection: Bool?
    
    var softwarePresenter = SoftwarePresenter()
    var softwares: [Softwares] = []
    
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
        icon.image = UIImage(named: "software")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
        let attachement = NSAttributedString(attachment: icon)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(attachement)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: "Softwares", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 18) as Any, .foregroundColor : UIColor.apTintColor as Any]))
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "What softwares would you like to highlight ?", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - TableView
    lazy var softwaresTableView: UITableView = {
        let table = UITableView()
        table.register(SoftwaresTableViewCell.self, forCellReuseIdentifier: SoftwaresTableViewCell.cellId)
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
            config.attributedTitle = AttributedString("Add Software", attributes: container)
            addSoftwareButton.configuration = config
            
        }else{
            
            let icon = NSTextAttachment()
            icon.image = UIImage(named: "add-section-circle")?.imageWithSize(CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal)
            icon.bounds = CGRect(x: 0, y: -4, width: icon.image!.size.width, height: icon.image!.size.width )
            
            let attachement = NSAttributedString(attachment: icon)
            let attributedText = NSMutableAttributedString(string: "")
            attributedText.append(attachement)
            attributedText.append(NSAttributedString(string: " "))
            
            attributedText.append(NSAttributedString(string: "Add Software", attributes: [
                .font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any,
                .foregroundColor : UIColor.apAddLabel as Any,
                .underlineStyle : NSUnderlineStyle.single.rawValue
            ]))
            
            addSoftwareButton.setAttributedTitle(attributedText, for: .normal)
        }
    }
    
    lazy var addSoftwareButton: UIButton = {
        
        let button = UIButton(type: .system)

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 3
            config.image = UIImage(named: "add-section-circle")?.imageWithSize(CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal)
            var container = AttributeContainer()
            container.font = UIFont(name: Theme.nunitoSansBold, size: 14)
            container.foregroundColor = .apAddLabel
            container.underlineStyle = .single
            config.attributedTitle = AttributedString("Add Software", attributes: container)
            button.configuration = config
            
        }else{
            
            let icon = NSTextAttachment()
            icon.image = UIImage(named: "add-section-circle")?.imageWithSize(CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal)
            icon.bounds = CGRect(x: 0, y: -4, width: icon.image!.size.width, height: icon.image!.size.width )
            
            let attachement = NSAttributedString(attachment: icon)
            let attributedText = NSMutableAttributedString(string: "")
            attributedText.append(attachement)
            attributedText.append(NSAttributedString(string: " "))
        
            attributedText.append(NSAttributedString(string: "Add Software", attributes: [
                .font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any,
                .foregroundColor : UIColor.apAddLabel as Any,
                .underlineStyle : NSUnderlineStyle.single.rawValue
            ]))
            
            button.setAttributedTitle(attributedText, for: .normal)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addSoftware), for: .touchUpInside)
        return button
    }()
    
    @objc func addSoftware(){
        
        let parsedForm = parseForm()
        if parsedForm.filter({ $0.key.trimmingCharacters(in: .whitespacesAndNewlines) == "" }).count > 0 {
            return
        }

        let context = CoreDataManager.shared.persistentContainer.viewContext

        let nElement = Softwares(context: context)
        nElement.title = ""
        nElement.level = Int16(3)
        nElement.orderIndex = Int16(self.softwares.count+1)
        nElement.initialObject = initialObject
        nElement.status = true

        if context.hasChanges {
            _ = formDataModel()
            try? context.save()
        }
        
        self.softwares.append(nElement)
        
        let row = IndexPath(row: self.softwares.count - 1, section: 0)
        
        self.softwaresTableView.insertRows(at: [row], with: .automatic)
        self.softwaresTableView.scrollToRow(at:row, at: .top, animated: true)

        if let cell = softwaresTableView.cellForRow(at: row) as? SoftwaresTableViewCell {
            if let textField = cell.contentView.subviews.filter({$0 is UITextField }).first as? AutocompleteField {
                textField.becomeFirstResponder()
            }
        }
    }
    
    private func formDataModel() -> [Softwares]{
                
        let _context = CoreDataManager.shared.persistentContainer.viewContext
                        
        for (_, sView) in softwaresTableView.subviews.enumerated() where sView is UITableViewCell && sView.isHidden == false {
            let cell = sView as! SoftwaresTableViewCell
            let neededSubviews = cell.subviews.first?.subviews.map({$0})
                        
            if let textField = neededSubviews?.filter({$0 is UITextField }).first as? AutocompleteField {
                                
                if let _text = textField.text, let stackRating = neededSubviews?.filter({$0 is UIStackView }).first as? RatingController {
                    
                    let objectID = cell.objectId
                    let title = _text.replacingOccurrences(of: "^\\s+|\\s+$", with: "", options: .regularExpression, range: nil)
                    let level = stackRating.starsRating
                    
                    if title.isEmpty, let objectID = objectID {
                        let object = _context.object(with: objectID)
                        _context.delete(object)
                        continue
                    }
                    
                    let software = self.softwares.first(where: { $0.objectID == objectID })
                    software?.title = title
                    software?.level = Int16(level)
                    software?.status = true
                }
            }
        }
        return self.softwares
    }
    
    
    @objc func didTapContinue(){
        _ = formDataModel()
        CoreDataManager.shared.setupSoftwares { [weak self] _ in
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
    
    private func parseForm() -> [String:Int] {
        
        var softwareDict = [String:Int]()
        
        //Clear Hidden Subviews
        for (_, sView) in softwaresTableView.subviews.enumerated() where sView is UITableViewCell && sView.isHidden == false {
            
            let neededSubviews = sView.subviews.first?.subviews.map({$0})
            
            if let textField = neededSubviews?.filter({$0 is UITextField }).first as? AutocompleteField {
                if let _text = textField.text, let stackRating = neededSubviews?.filter({$0 is UIStackView }).first as? RatingController {
                    softwareDict[_text] = stackRating.starsRating
                }
            }
        }
        return softwareDict
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
        let uColor = UIColor.apTintColor.withAlphaComponent(0.8)
        
        let attributedText = NSMutableAttributedString(string: "Back", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor : uColor as Any])
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      else {
        return
      }
        
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        softwaresTableView.contentInset = contentInsets
        softwaresTableView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
      // reset back the content inset to zero after keyboard is gone
        softwaresTableView.contentInset = contentInsets
        softwaresTableView.scrollIndicatorInsets = contentInsets
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        softwarePresenter.delegate = self
        softwarePresenter.fetchSoftwaresList(initialObject: initialObject)
                
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
        
        //TableView
        softwaresTableView.dragInteractionEnabled = true
        
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
        
        view.addSubview(softwaresTableView)
        
        NSLayoutConstraint.activate([
            softwaresTableView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 15),
            softwaresTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            softwaresTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            softwaresTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: - Table Footer View
        softwaresTableView.tableFooterView = buttonsStack
        softwaresTableView.tableFooterView?.frame.size.height = 160
        
        buttonsStack.addSubview(addSoftwareButton)
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
            
            addSoftwareButton.topAnchor.constraint(equalTo: buttonsStack.topAnchor, constant: 20),
            addSoftwareButton.trailingAnchor.constraint(equalTo: buttonsStack.trailingAnchor, constant: -5),
        ])
        
        //Update Constraints
        softwaresTableView.layoutIfNeeded()
    }
    
}


extension SoftwaresVC: SoftwarePresenterDelegate {
    func presentSoftwares(list: [Softwares]) {
        self.softwares = list
        
        if list.count == 0 {
            self.addSoftware()
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.softwaresTableView.reloadData()
        }
    }
}

extension SoftwaresVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, completion) in
            
            if let software = self?.softwares[indexPath.row] {
                
                self?.softwares.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // Clear subviews
                _ = tableView.subviews.enumerated()
                    .filter({ $1 is UITableViewCell && $1.alpha == 0 })
                    .map({$1.removeFromSuperview()})
                
                CoreDataManager.shared.removeObject(objectId: software.objectID) { _ in
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
        return self.softwares.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SoftwaresTableViewCell.cellId, for: indexPath) as! SoftwaresTableViewCell
        
        let software = self.softwares[indexPath.row]
        
        cell.software = software
        cell.tag = indexPath.row
        cell.objectId = software.objectID
        
        cell.keyboardReturnTapped = { [weak self] in
            let parsedForm = self?.parseForm()
            if let parsed_ = parsedForm?.filter({ $0.key.trimmingCharacters(in: .whitespacesAndNewlines) == "" }), parsed_.count > 0 {
                return
            }
            self?.addSoftware()
        }
        
        
        cell.ratingStackView.ratingObserver = { rating in
            //update raing on single Cell
            
            if let objectID = cell.objectId {
                let level = rating

                let viewContext = CoreDataManager.shared.persistentContainer.viewContext
                let software = viewContext.object(with: objectID) as! Softwares
                software.level = Int16(level)
                try? viewContext.save()

            }
        }
        
        return cell
    }
    
}
