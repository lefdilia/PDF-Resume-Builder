//
//  WorkExperiencesListVC.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 11/1/2022.
//

import UIKit
import CoreData


class WorkExperiencesListVC: UIViewController {
    
    weak var initialObject: Initial?
    var presentingMainSection: Bool?
    
    var workExperiencesPresenter = WorkExperiencesPresenter()
    var workExperiencesList: [WorkExperiences] = []
    
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
        icon.image = UIImage(named: "workExperience")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
        let attachement = NSAttributedString(attachment: icon)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(attachement)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: "Work Experiences", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 18) as Any, .foregroundColor : UIColor.apTintColor as Any]))

        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "List of saved work experiences", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    //MARK: - Section
    lazy var addSection: AddNewSection = {
        let _view = AddNewSection(title: "Add Another Position", color: .apBorder, lineWidth: 1.4, icon: .customLight(height: 40, width: 40))
        _view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddSection)))
        _view.addButton.addTarget(self, action: #selector(didTapAddSection), for: .touchUpInside)
        
        return _view
    }()
    
    @objc func didTapAddSection(){
        let workExperiencesVC = WorkExperiencesVC()
        workExperiencesVC.initialObject = initialObject
        
        workExperiencesVC.saveHandler = { [weak self] in
            self?.workExperiencesPresenter.fetchWorkExperiences(initialObject: self?.initialObject)
        }
        
        workExperiencesVC.modalPresentationStyle = .fullScreen
        present(workExperiencesVC, animated: true, completion: nil)
    }
    //MARK: - TableView
    lazy var workTableView: UITableView = {
        let table = UITableView()
        table.register(WorkExperiencesTableViewCell.self, forCellReuseIdentifier: WorkExperiencesTableViewCell.cellId)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .apBackground
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.estimatedRowHeight = 120
        table.rowHeight = UITableView.automaticDimension
        table.isUserInteractionEnabled = true
                
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapOnCell))
        table.addGestureRecognizer(gesture)

        table.allowsSelection = false
        table.allowsSelectionDuringEditing = false
        return table
    }()
    
    @objc func didTapOnCell(gesture: UITapGestureRecognizer){
        for cell in workTableView.visibleCells {
            cell.contentView.subviews.first(where: { $0.accessibilityLabel == "globalView" })?.layer.borderWidth = 1
        }
    }
    
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
        var button = UIButton(type: .system)
        let uColor = UIColor.apTintColor.withAlphaComponent(0.8)
        
        let attributedText = NSMutableAttributedString(string: "Cancel", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor : uColor as Any])
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = .apBackground
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.apBorderJobCell.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()

    let buttonsStack: UIView = {
        let _view = UIView()
        _view.backgroundColor = .blue.withAlphaComponent(0.3)
        return _view
    }()
    
    @objc func didTapContinue(){

        if presentingMainSection == true {
            let educationListVC = EducationListVC()
            educationListVC.initialObject = initialObject
            educationListVC.presentingMainSection = presentingMainSection
            self.navigationController?.pushViewController(educationListVC, animated: true)
        }else{
            let educationVC = EducationVC()
            educationVC.initialObject = initialObject
            self.navigationController?.pushViewController(educationVC, animated: true)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        backButton.backgroundColor = .apBackground
        backButton.layer.borderColor = UIColor.apBorderJobCell.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Main Section Save Button
        if presentingMainSection == true && initialObject?.status == true {
            let cancelAttributedText = NSMutableAttributedString(string: "Back", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8) as Any])
            backButton.setAttributedTitle(cancelAttributedText, for: .normal)
            
            let attributedText = NSMutableAttributedString(string: "Next Section", attributes: [
                .font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any,
                .foregroundColor: UIColor.white as Any])
            continueButton.backgroundColor = .apContinueButton
            continueButton.setAttributedTitle(attributedText, for: .normal)
        }
        
        //MARK: - Setup Views
        workExperiencesPresenter.delegate = self
        workExperiencesPresenter.fetchWorkExperiences(initialObject: initialObject)
        
        view.backgroundColor = .apBackground
        
        //TableView
        workTableView.dragInteractionEnabled = true
        workTableView.dropDelegate = self
        
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
        
        view.addSubview(workTableView)
        
        NSLayoutConstraint.activate([
            workTableView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 15),
            workTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            workTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            workTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        addSection.separatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        workTableView.tableHeaderView = addSection
        workTableView.tableHeaderView?.frame.size.height = 100
        
        //MARK: - Table Footer View
        workTableView.tableFooterView = buttonsStack
        workTableView.tableFooterView?.frame.size.height = 200

        buttonsStack.addSubview(backButton)
        buttonsStack.addSubview(continueButton)

                
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: buttonsStack.centerYAnchor, constant: -20),
            backButton.centerXAnchor.constraint(equalTo: buttonsStack.centerXAnchor, constant: -80),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 150),
            
            continueButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
            continueButton.widthAnchor.constraint(equalToConstant: 150),

            continueButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10)
        ])
        
        //Update Constraints
        workTableView.layoutIfNeeded()
    }

}

extension WorkExperiencesListVC: WorkExperiencesPresenterDelegate {
    func presentWorkExperiences(list: [WorkExperiences]) {
        self.workExperiencesList = list

        DispatchQueue.main.async { [weak self] in
            self?.workTableView.reloadData()
        }
    }
}

extension WorkExperiencesListVC: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        tableView.cellForRow(at: indexPath)?.contentView.subviews.first(where: { $0.accessibilityLabel == "globalView" })?.layer.borderWidth = 0

        return [UIDragItem(itemProvider: NSItemProvider())]
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
}

extension WorkExperiencesListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { (_, _, completion) in
            let work = self.workExperiencesList[indexPath.row]
            
            CoreDataManager.shared.deleteWorkExperience(work: work) { [weak self] _ in
                self?.workExperiencesList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
                completion(true)
            }
        }
        
        deleteAction.backgroundColor = .white
        deleteAction.image = UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(scale: .small))?.withTintColor(.appleBlossom).withRenderingMode(.alwaysOriginal)
        
        let swipes = UISwipeActionsConfiguration(actions: [deleteAction])
        swipes.performsFirstActionWithFullSwipe = false
        
        return swipes
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let mover = self.workExperiencesList.remove(at: sourceIndexPath.row)
        self.workExperiencesList.insert(mover, at: destinationIndexPath.row)

        tableView.cellForRow(at: sourceIndexPath)?.contentView.subviews.first(where: { $0.accessibilityLabel == "globalView" })?.layer.borderWidth = 1
        
        CoreDataManager.shared.updateDisplayOrder(list: self.workExperiencesList) { _ in
            DispatchQueue.main.async {
                tableView.reloadData() // to fix Order in indexPath
            }
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {
        for cell in tableView.visibleCells {
            cell.contentView.subviews.first(where: { $0.accessibilityLabel == "globalView" })?.layer.borderWidth = 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let gbView = UIView()
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = "No work experience found. Please try to add one..."
            label.textColor = .apTintColor
            label.textAlignment = .center
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: Theme.nunitoSansSemiBold, size: 15)
            return label
        }()
        
        gbView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: gbView.topAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: gbView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: gbView.trailingAnchor),
            messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
        
        return gbView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.workExperiencesList.count == 0 ? 350 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workExperiencesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WorkExperiencesTableViewCell.cellId, for: indexPath) as! WorkExperiencesTableViewCell
        
        let work =  self.workExperiencesList[indexPath.row]
        
        cell.workExperience = work
        
        cell.editButtonapped = { [weak self] in
            let workExperiencesVC = WorkExperiencesVC()
            workExperiencesVC.work = work
            
            workExperiencesVC.saveHandler = {
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }

            workExperiencesVC.modalPresentationStyle = .fullScreen
            self?.present(workExperiencesVC, animated: true, completion: nil)
            
        }
        
        return cell
    }
    


    
}

