//
//  InterestVC.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 2/2/2022.
//

import UIKit
import CoreData

class InterestsVC: UIViewController, initialObjectDataSource {

    weak var initialObject: Initial?
    var presentingMainSection: Bool?

    var interestsPresenter = InterestsPresenter()
    var interests: [Interests] = []

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
        icon.image = UIImage(named: "interest")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
        let attachement = NSAttributedString(attachment: icon)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(attachement)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: "Interests", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 18) as Any, .foregroundColor : UIColor.apTintColor as Any]))
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "You should add some hobbies and interests", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: - TableView
    lazy var interestsTableView: UITableView = {
        let table = UITableView()
        table.register(InterestsTableViewCell.self, forCellReuseIdentifier: InterestsTableViewCell.cellId)
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
            config.attributedTitle = AttributedString("Add Interest", attributes: container)
            addInterestButton.configuration = config
            
        }else{
            
            let icon = NSTextAttachment()
            icon.image = UIImage(named: "add-section-circle")?.imageWithSize(CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal)
            icon.bounds = CGRect(x: 0, y: -4, width: icon.image!.size.width, height: icon.image!.size.width )
            
            let attachement = NSAttributedString(attachment: icon)
            let attributedText = NSMutableAttributedString(string: "")
            attributedText.append(attachement)
            attributedText.append(NSAttributedString(string: " "))
            
            attributedText.append(NSAttributedString(string: "Add Interest", attributes: [
                .font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any,
                .foregroundColor : UIColor.apAddLabel as Any,
                .underlineStyle : NSUnderlineStyle.single.rawValue
            ]))
            
            addInterestButton.setAttributedTitle(attributedText, for: .normal)
        }
    }
    
    lazy var addInterestButton: UIButton = {
        
        let button = UIButton(type: .system)

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 3
            config.image = UIImage(named: "add-section-circle")?.imageWithSize(CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal)
            var container = AttributeContainer()
            container.font = UIFont(name: Theme.nunitoSansBold, size: 14)
            container.foregroundColor = .apAddLabel
            container.underlineStyle = .single
            config.attributedTitle = AttributedString("Add Interest", attributes: container)
            button.configuration = config
            
        }else{
            
            let icon = NSTextAttachment()
            icon.image = UIImage(named: "add-section-circle")?.imageWithSize(CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal)
            icon.bounds = CGRect(x: 0, y: -4, width: icon.image!.size.width, height: icon.image!.size.width )
            
            let attachement = NSAttributedString(attachment: icon)
            let attributedText = NSMutableAttributedString(string: "")
            attributedText.append(attachement)
            attributedText.append(NSAttributedString(string: " "))
        
            attributedText.append(NSAttributedString(string: "Add Interest", attributes: [
                .font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any,
                .foregroundColor : UIColor.apAddLabel as Any,
                .underlineStyle : NSUnderlineStyle.single.rawValue
            ]))
            
            button.setAttributedTitle(attributedText, for: .normal)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addInterest), for: .touchUpInside)
        return button
    }()
    
    @objc func addInterest(){
        
        let parsedForm = parseForm()
        if parsedForm.filter({ $0.trimmingCharacters(in: .whitespacesAndNewlines) == "" }).count > 0 {
            return
        }

        let context = CoreDataManager.shared.persistentContainer.viewContext

        let nElement = Interests(context: context)
        nElement.title = ""
        nElement.orderIndex = Int16(self.interests.count+1)
        nElement.initialObject = initialObject

        if context.hasChanges {
            _ = formDataModel()
            try? context.save()
        }
        
        self.interests.append(nElement)
        
        let row = IndexPath(row: self.interests.count - 1, section: 0)
        
        self.interestsTableView.insertRows(at: [row],with: .automatic)
        self.interestsTableView.scrollToRow(at:row, at: .top, animated: true)

        if let cell = interestsTableView.cellForRow(at: row) as? InterestsTableViewCell {
            
            if let textField = cell.contentView.subviews.filter({$0 is UITextField }).first as? AutocompleteField {
                textField.becomeFirstResponder()
            }
        }
    }
    
    private func formDataModel() -> [Interests]{
                
        let _context = CoreDataManager.shared.persistentContainer.viewContext
                        
        for (_, sView) in interestsTableView.subviews.enumerated() where sView is UITableViewCell && sView.isHidden == false {
            let cell = sView as! InterestsTableViewCell
            let neededSubviews = cell.subviews.first?.subviews.map({$0})
                        
            if let textField = neededSubviews?.filter({$0 is UITextField }).first as? AutocompleteField {
                                
                if let _text = textField.text {
                    
                    let objectID = cell.objectId
                    let title = _text.replacingOccurrences(of: "^\\s+|\\s+$", with: "", options: .regularExpression, range: nil)
                    
                    if title.isEmpty, let objectID = objectID {
                        let object = _context.object(with: objectID)
                        _context.delete(object)
                        continue
                    }
                    
                    let interest = self.interests.first(where: { $0.objectID == objectID })
                    interest?.title = title
                    interest?.status = true
                }
            }
        }
        return self.interests
    }
    
    @objc func didTapContinue(){
        _ = formDataModel()
        
        CoreDataManager.shared.setupInterests { [weak self] _ in
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
        
        var interestDict = [String]()
        
        //Clear Hidden Subviews
        for (_, sView) in interestsTableView.subviews.enumerated() where sView is UITableViewCell && sView.isHidden == false {
            
            let neededSubviews = sView.subviews.first?.subviews.map({$0})
            
            if let textField = neededSubviews?.filter({$0 is UITextField }).first as? AutocompleteField {
                if let _text = textField.text {
                    interestDict.append(_text)
                }
            }
        }
        return interestDict
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
        interestsTableView.contentInset = contentInsets
        interestsTableView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
      // reset back the content inset to zero after keyboard is gone
        interestsTableView.contentInset = contentInsets
        interestsTableView.scrollIndicatorInsets = contentInsets
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interestsPresenter.delegate = self
        interestsPresenter.fetchInterestList(initialObject: initialObject)
        
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
        
        view.addSubview(interestsTableView)
        
        NSLayoutConstraint.activate([
            interestsTableView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 15),
            interestsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            interestsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            interestsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: - Table Footer View
        interestsTableView.tableFooterView = buttonsStack
        interestsTableView.tableFooterView?.frame.size.height = 160
        
        buttonsStack.addSubview(addInterestButton)
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
            
            addInterestButton.topAnchor.constraint(equalTo: buttonsStack.topAnchor, constant: 20),
            addInterestButton.trailingAnchor.constraint(equalTo: buttonsStack.trailingAnchor, constant: -5),
        ])
        
        //Update Constraints
        interestsTableView.layoutIfNeeded()
    }
    
}

extension InterestsVC: InterestsPresenterDelegate {
    func presentInterests(list: [Interests]) {
        self.interests = list
        
        if list.count == 0 {
            self.addInterest()
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.interestsTableView.reloadData()
        }
    }
}

extension InterestsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, completion) in
            
            if let interest = self?.interests[indexPath.row] {
                
                self?.interests.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // Clear subviews
                _ = tableView.subviews.enumerated()
                    .filter({ $1 is UITableViewCell && $1.alpha == 0 })
                    .map({$1.removeFromSuperview()})
            
                CoreDataManager.shared.removeObject(objectId: interest.objectID) { _ in
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
        return self.interests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: InterestsTableViewCell.cellId, for: indexPath) as! InterestsTableViewCell
        
        let interest = self.interests[indexPath.row]
        
        cell.interest = interest
        cell.objectId = interest.objectID
        
        cell.keyboardReturnTapped = { [weak self] in
            let parsedForm = self?.parseForm()
            if let parsed_ = parsedForm?.filter({ $0.trimmingCharacters(in: .whitespacesAndNewlines) == "" }), parsed_.count > 0 {
                return
            }
            self?.addInterest()
        }
        
        
        return cell
    }
    
}
