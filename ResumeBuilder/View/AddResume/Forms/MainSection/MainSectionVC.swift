//
//  MainSectionVC.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 16/1/2022.
//

import UIKit
import CoreData

class MainSectionVC: UIViewController, initialObjectDataSource {
    
    var arrayOfSections: [MainSections]?
    
    var mainSections: [MainSections] = [.contactInformations, .workExperiences, .education, .skills, .languages, .summary]
    
    var initialObject: Initial? {
        didSet {
            arrayOfSections = []
            
            guard let initialObject = initialObject else { return }
            
            arrayOfSections?.append(.contactInformations)
            arrayOfSections?.append(.workExperiences)
            arrayOfSections?.append(.education)
            arrayOfSections?.append(.skills)
            arrayOfSections?.append(.languages)
            arrayOfSections?.append(.summary)
            
            //Extra Sections
            if let accomplishments = initialObject.accomplishments?.allObjects as? [Accomplishments], accomplishments.filter({ $0.status == true }).count > 0 {
                arrayOfSections?.append(.accomplishments)
            }
            
            if let additionalInformation = initialObject.additionalInformation?.allObjects as? [AdditionalInformation], additionalInformation.filter({ $0.status == true }).count > 0 {
                arrayOfSections?.append(.additionalInformation)
            }
            
            if let certifications = initialObject.certifications?.allObjects as? [Certifications], certifications.filter({ $0.status == true }).count > 0 {
                arrayOfSections?.append(.certifications)
            }
            
            if let interests = initialObject.interests?.allObjects as? [Interests], interests.filter({ $0.status == true }).count > 0 {
                arrayOfSections?.append(.interests)
            }
            
            if let softwares = initialObject.softwares?.allObjects as? [Softwares], softwares.filter({ $0.status == true }).count > 0 {
                arrayOfSections?.append(.softwares)
            }
            
            //Custom sections
            //always at bottom
            if let customSection = initialObject.customSection?.allObjects as? [CustomSection] {
                for (_, section) in customSection.enumerated() {
                    if let title = section.title {
                        let _section: MainSections = .custom(title: title, slogan: "Custom Section", objectId: section.objectID)
                        arrayOfSections?.append(_section)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.mainSectionsTableView.reloadData()
            }
        }
    }
    
    //MARK: - TableView
    lazy var mainSectionsTableView: UITableView = {
        let table = UITableView()
        table.register(MainSectionsTableViewCell.self, forCellReuseIdentifier: MainSectionsTableViewCell.cellId)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .apBackground
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.estimatedRowHeight = 110
        table.rowHeight = UITableView.automaticDimension
        table.isUserInteractionEnabled = true
        table.allowsSelectionDuringEditing = false
        return table
    }()
    
    //MARK: - Setup Views
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
        icon.image = UIImage(named: "sections-icon")?.withTintColor(.apTintColor).withRenderingMode(.alwaysOriginal)
        icon.bounds = CGRect(x: 0, y: -2, width: icon.image!.size.width, height: icon.image!.size.width )
        let attachement = NSAttributedString(attachment: icon)
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.append(attachement)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(NSAttributedString(string: "Resume Sections", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 18) as Any, .foregroundColor : UIColor.apTintColor as Any]))
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "List of resume sections", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var addNewSection: AddNewSection = {
        let addNewSection = AddNewSection(title: "Add Section", color: .apBorder, lineWidth: 1.4, icon: .customLight(height: 40, width: 40))
        addNewSection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddSection)))
        addNewSection.addButton.addTarget(self, action: #selector(didTapAddSection), for: .touchUpInside)
        return addNewSection
    }()
    
    @objc func didTapAddSection(){
        
        let addSection = AddSectionVC()
        addSection.initialObject = initialObject
        addSection.modalPresentationStyle = .fullScreen
        
        if let target = popTo(AddSectionVC.self), target == false {
            self.navigationController?.pushViewController(addSection, animated: true)
        }
        
        addSection.passData = { [weak self] _initialObject in
            DispatchQueue.main.async {
                self?.initialObject = _initialObject
            }
        }
    }
    
    @objc func didTapClose(){
        
        if let status = initialObject?.status, status == false {
            
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
            
        }else{
            
            if let mainTabBar = self.navigationController?.presentingViewController as? MainTabBarController {
                if let exploreNavigationController = mainTabBar.viewControllers?.first(where: { $0.tabBarItem.tag == 1 }) as? UINavigationController {
                    if let exploreViewController = exploreNavigationController.viewControllers.first as? ExploreViewController {
                        exploreViewController.finalizedStage?()
                    }
                }
                
                if let homeNavigationController = mainTabBar.viewControllers?.first(where: { $0.tabBarItem.tag == 0 }) as? UINavigationController {
                    if let homeViewController = homeNavigationController.viewControllers.first as? HomeViewController {
                        homeViewController.finalizedStage?()
                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Final Buttons
    
    let buttonsStack: UIView = {
        let _view = UIView()
        return _view
    }()
    
    lazy var finalizeButton: UIButton = {
        var button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Finalize Resume", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 14) as Any, .foregroundColor : UIColor.white as Any ])
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = .apContinueButton
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapfinalize), for: .touchUpInside)
        return button
    }()
    
    lazy var previewButton: UIButton = {
        
        var button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "")
        
        if #available(iOS 15.0, *) {
            
            var configuration = UIButton.Configuration.plain()
            configuration.image = UIImage(named: "preview")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
            configuration.imagePadding = 6
            button.configuration = configuration
            
        }else{
            
            let icon = NSTextAttachment()
            icon.image = UIImage(named: "preview")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
            icon.bounds = CGRect(x: 0, y: -4, width: icon.image!.size.width, height: icon.image!.size.width )
            
            let attachement = NSAttributedString(attachment: icon)
            attributedText.append(attachement)
            attributedText.append(NSAttributedString(string: " "))

        }
        
        attributedText.append(NSAttributedString(string: "Preview", attributes: [
            .font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any,
            .foregroundColor : UIColor.white as Any
        ]))
        
        button.setAttributedTitle(attributedText, for: .normal)
        
        button.backgroundColor = .apUpdateButton
        button.layer.cornerRadius = 3
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapPreview), for: .touchUpInside)
        return button
    }()
    
    @objc func didTapfinalize(){
        
        CoreDataManager.shared.finalizeResume(initialObject: initialObject) { [weak self] _ in
            
            if let mainTabBar = self?.navigationController?.presentingViewController as? MainTabBarController {
                if let exploreNavigationController = mainTabBar.viewControllers?.first(where: { $0.tabBarItem.tag == 1 }) as? UINavigationController {
                    if let exploreViewController = exploreNavigationController.viewControllers.first as? ExploreViewController {
                        exploreViewController.finalizedStage?()
                    }
                }
                
                if let homeNavigationController = mainTabBar.viewControllers?.first(where: { $0.tabBarItem.tag == 0 }) as? UINavigationController {
                    if let homeViewController = homeNavigationController.viewControllers.first as? HomeViewController {
                        homeViewController.finalizedStage?()
                    }
                }
            }
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func didTapPreview(){
        
        let previewResume = PreviewResumeViewController()
        
        previewResume.initialObject = initialObject
        previewResume.resumeData = initialObject?.buildResume()
        
        let navController = UINavigationController(rootViewController: previewResume)
        navController.modalPresentationStyle = .overFullScreen
        navController.setNavigationBarHidden(true, animated: true)
        self.present(navController, animated: true, completion: nil)
        
        previewResume.passData = { [weak self] selectedItem in
            CoreDataManager.shared.updateInitial(options: selectedItem, initialObject: self?.initialObject, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .apBackground
        
        view.addSubview(closeVCButton)
        view.addSubview(titleLabel)
        view.addSubview(sloganLabel)
        
        NSLayoutConstraint.activate([
            closeVCButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeVCButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: closeVCButton.bottomAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            sloganLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            sloganLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            sloganLabel.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        view.addSubview(mainSectionsTableView)
        
        NSLayoutConstraint.activate([
            mainSectionsTableView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 15),
            mainSectionsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainSectionsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            mainSectionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addNewSection.separatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        mainSectionsTableView.tableHeaderView = addNewSection
        mainSectionsTableView.tableHeaderView?.frame.size.height = 100
        
        //MARK: - Table Footer View
        mainSectionsTableView.tableFooterView = buttonsStack
        mainSectionsTableView.tableFooterView?.frame.size.height = 140
        
        buttonsStack.addSubview(previewButton)
        buttonsStack.addSubview(finalizeButton)
        
        NSLayoutConstraint.activate([
            
            previewButton.bottomAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: -20),
            previewButton.heightAnchor.constraint(equalToConstant: 40),
            previewButton.widthAnchor.constraint(equalToConstant: 110),
            
            previewButton.centerXAnchor.constraint(equalTo: buttonsStack.centerXAnchor, constant: -80),
            
            finalizeButton.centerYAnchor.constraint(equalTo: previewButton.centerYAnchor),
            finalizeButton.heightAnchor.constraint(equalToConstant: 40),
            finalizeButton.widthAnchor.constraint(equalToConstant: 150),
            finalizeButton.leadingAnchor.constraint(equalTo: previewButton.trailingAnchor, constant: 10),
            
        ])
        
        //Update Constraints
        mainSectionsTableView.layoutSubviews()
        mainSectionsTableView.layoutIfNeeded()
        
    }
    
}


extension MainSectionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let section = self.arrayOfSections?[indexPath.row] else { return nil }
        
        if mainSections.contains(section) {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { (_, _, completion) in
            
            CoreDataManager.shared.removeSection(section: section, initialObject: self.initialObject) { [weak self] _ in
                
                self?.arrayOfSections?.remove(at: indexPath.row)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfSections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MainSectionsTableViewCell.cellId, for: indexPath) as! MainSectionsTableViewCell
        
        guard let sectionIn = self.arrayOfSections?[indexPath.row] else { return UITableViewCell() }
        
        cell.sectionIn = sectionIn
        
        if mainSections.contains(sectionIn) {
            cell.rightView.isHidden = true
        }else{
            cell.rightView.isHidden = false
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = self.arrayOfSections?[indexPath.row] else { return }
        
        if section == .contactInformations {
            if let target = popTo(ContactInformationsVC.self), target == false {
                let _initVC = ContactInformationsVC()
                _initVC.initialObject = initialObject
                _initVC.presentingMainSection = true
                self.navigationController?.pushViewController(_initVC, animated: true)
            }
        }
        
        if section == .workExperiences {
            if let target = popTo(WorkExperiencesListVC.self), target == false {
                let _initVC = WorkExperiencesListVC()
                _initVC.initialObject = initialObject
                _initVC.presentingMainSection = true
                self.navigationController?.pushViewController(_initVC, animated: true)
            }
        }
        
        if section == .education {
            if let target = popTo(EducationListVC.self), target == false {
                let _initVC = EducationListVC()
                _initVC.initialObject = initialObject
                _initVC.presentingMainSection = true
                self.navigationController?.pushViewController(_initVC, animated: true)
            }
        }
        
        if section == .skills {
            if let target = popTo(SkillsVC.self), target == false {
                let _initVC = SkillsVC()
                _initVC.initialObject = initialObject
                _initVC.presentingMainSection = true
                self.navigationController?.pushViewController(_initVC, animated: true)
            }
        }
        
        if section == .languages {
            if let target = popTo(LanguagesVC.self), target == false {
                let _initVC = LanguagesVC()
                _initVC.initialObject = initialObject
                _initVC.presentingMainSection = true
                self.navigationController?.pushViewController(_initVC, animated: true)
            }
        }
        
        if section == .summary {
            if let target = popTo(SummaryVC.self), target == false {
                let _initVC = SummaryVC()
                _initVC.initialObject = initialObject
                _initVC.presentingMainSection = true
                self.navigationController?.pushViewController(_initVC, animated: true)
            }
        }
        
        //MARK: - Side Sections
        
        if section == .accomplishments {
            if let target = popTo(AccomplishmentsVC.self), target == false {
                let _initVC = AccomplishmentsVC()
                _initVC.initialObject = initialObject
                _initVC.presentingMainSection = true
                self.navigationController?.pushViewController(_initVC, animated: true)
            }
        }
        
        if section == .additionalInformation {
            if let target = popTo(AdditionalInformationVC.self), target == false {
                let _initVC = AdditionalInformationVC()
                _initVC.initialObject = initialObject
                _initVC.presentingMainSection = true
                self.navigationController?.pushViewController(_initVC, animated: true)
            }
        }
        
        if section == .certifications {
            if let target = popTo(CertificationsVC.self), target == false {
                let _initVC = CertificationsVC()
                _initVC.initialObject = initialObject
                _initVC.presentingMainSection = true
                self.navigationController?.pushViewController(_initVC, animated: true)
            }
        }
        
        if section == .interests {
            if let target = popTo(InterestsVC.self), target == false {
                let _initVC = InterestsVC()
                _initVC.initialObject = initialObject
                _initVC.presentingMainSection = true
                self.navigationController?.pushViewController(_initVC, animated: true)
            }
        }
        
        if section == .softwares {
            if let target = popTo(SoftwaresVC.self), target == false {
                let _initVC = SoftwaresVC()
                _initVC.initialObject = initialObject
                _initVC.presentingMainSection = true
                self.navigationController?.pushViewController(_initVC, animated: true)
            }
        }
        
        //MARK: - Custom Section
        
        if section.infos.entity is CustomSection.Type {
            
            let _initVC = CustomSectionVC()
            _initVC.customSection = section
            _initVC.initialObject = initialObject
            _initVC.presentingMainSection = true
            if let target = popTo(CustomSectionVC.self), target == false {
                self.navigationController?.pushViewController(_initVC, animated: true)
                _initVC.passData = { [weak self] _initialObject in
                    self?.initialObject = _initialObject
                }
            }
        }
    }
}
