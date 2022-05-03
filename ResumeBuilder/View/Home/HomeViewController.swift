//
//  HomeViewController.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 5/11/2021.
//

import Foundation
import UIKit


class HomeViewController: UIViewController {
    
    let userDataPresenter = UserDataPresenter()
    let jobsListChildController = JobsListChildController()
    
    var userData = [UserData]() {
        didSet{
            if collectionViewHeightConstraint != nil {
                let count = userData.count
                
                UIView.animate(withDuration: 0.4) { [weak self] in
                    if count > 0 {
                        self?.collectionViewHeightConstraint.constant = 120
                    }else{
                        self?.collectionViewHeightConstraint.constant = 80
                    }
                }
            }
        }
    }
    
    var finalizedStage: (()->())?
    
    //MARK: - Top Header (CollectionView)
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .apBackground
        collectionView.register(TopResumeListCell.self, forCellWithReuseIdentifier: TopResumeListCell.cellId)
        collectionView.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionReusableView.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    //MARK: - Top Form
    lazy var jobsTitleLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "Jobs you may be interested in.", attributes: [.font : UIFont(name: Theme.SFUITextMedium, size: 15) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - ViewDidLoad
    var collectionViewHeightConstraint: NSLayoutConstraint!
    var collectionViewTopAnchorConstraint: NSLayoutConstraint!
    var jobsListTopAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDataPresenter.delegate = self
        userDataPresenter.getInitList()
        
        jobsListChildController.delegate = self
        jobsListChildController.data = self
        
        view.backgroundColor = .apBackground
        navigationItem.title = "Resumes"

        
        //Setup Flexible constraints
        if userData.count > 0 {
            collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 120)
        }else{
            collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 80)
        }
        
        collectionViewHeightConstraint.priority = UILayoutPriority(250)
        
        collectionViewTopAnchorConstraint = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        jobsListTopAnchorConstraint = jobsListChildController.view.topAnchor.constraint(equalTo: jobsTitleLabel.bottomAnchor, constant: 15)
        
        //MARK: - Setup Top CollectionView
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionViewTopAnchorConstraint,
            collectionViewHeightConstraint,
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        //MARK: - Top Form
        view.addSubview(jobsTitleLabel)
        
        NSLayoutConstraint.activate([
            jobsTitleLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15),
            jobsTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            jobsTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
        ])
        
        //MARK: - Job Listing TableView
        addChild(jobsListChildController)
        view.addSubview(jobsListChildController.view)
        jobsListChildController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            jobsListTopAnchorConstraint,
            jobsListChildController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            jobsListChildController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            jobsListChildController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        finalizedStage = { [weak self] in
            self?.userDataPresenter.getInitList()
            
            if let count = self?.userData.count, count > 0 {
                self?.collectionViewHeightConstraint.constant = 120
            }else{
                self?.collectionViewHeightConstraint.constant = 80
            }
            
            self?.view.layoutIfNeeded()
        }
    }

}


extension HomeViewController: JobsListChildControllerDeletgate {
    
    func tableViewDidScroll(yCoordinate: CGFloat) {
        
        if yCoordinate > 40.0 {
            collectionViewHeightConstraint.constant = 0
            collectionViewTopAnchorConstraint.constant = 0
            jobsListTopAnchorConstraint.constant = 10
        }else{
            if userData.count > 0 {
                collectionViewHeightConstraint.constant = 120
            }else{
                collectionViewHeightConstraint.constant = 80
            }
            
            collectionViewTopAnchorConstraint.constant = 10
            jobsListTopAnchorConstraint.constant = 15
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopResumeListCell.cellId, for: indexPath) as! TopResumeListCell
        
        let userData = userData[indexPath.item]
        cell.userData = userData
        
        let objectId = userData.objectID
        
        cell.editClosure = { [weak self] in
            
            CoreDataManager.shared.findResumeById(objectID: objectId) { initialObject in
                
                if let target = self?.popTo(MainSectionVC.self), target == false {
                    let mainViewController = MainSectionVC()
                    mainViewController.initialObject = initialObject
                    let _initVC = UINavigationController(rootViewController: mainViewController)
                    _initVC.modalPresentationStyle = .overFullScreen
                    _initVC.setNavigationBarHidden(true, animated: true)
                    self?.present(_initVC, animated: true, completion: nil)
                }
                
            }
        }
        
        //MARK: - Share Action
        cell.shareClosure = {
            
            let fileManager = FileManager.default
            
            CoreDataManager.shared.findResumeById(objectID: objectId) { initialObject in
                
                TemplatesGenerator().build(options: initialObject, final: true) { _, filePath, _ in
                    
                    guard let filePath = filePath?.relativePath else { return }
                    guard let contactInformations = initialObject?.contactInformations?.allObjects.first as? ContactInformations else { return }
                    
                    let identifier = initialObject?.identifier
                    
                    let firstName = contactInformations.firstName ?? ""
                    let lastName = contactInformations.lastName ?? ""
                    
                    var fileName = "\(firstName.capitalized) \(lastName.capitalized)"
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .replacingOccurrences(of: " ", with: "-")
                    
                    if fileName.isEmpty == true {
                        fileName = identifier?.uuidString ?? UUID().uuidString
                    }
                    
                    let sharedMessage = "Resume-\(fileName).pdf"
                    
                    if fileManager.fileExists(atPath: filePath) {
                        
                        let _file = URL(fileURLWithPath: filePath).createLinkToFile(withName: sharedMessage)
                        
                        guard let _file = _file else { return }
                        
                        let activityViewController = UIActivityViewController(activityItems: [_file], applicationActivities: nil)
                        activityViewController.excludedActivityTypes = [.airDrop]
                        
                        DispatchQueue.main.async {
                            if let popoverController = activityViewController.popoverPresentationController {
                                popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                                popoverController.sourceView = self.view
                                popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                            }
                            
                            activityViewController.completionWithItemsHandler = { activity, success, items, error in
                                UINavigationBar.appearance().tintColor = .white
                                activityViewController.dismiss(animated: true)
                            }
                            
                            self.present(activityViewController, animated: true) {() -> Void in
                                UINavigationBar.appearance().tintColor = .darkGray
                            }
                        }
                    }
                }
            }
        }
        
        //MARK: - Download Action
        cell.downloadClosure = {
            
            CoreDataManager.shared.findResumeById(objectID: objectId) { initialObject in
                
                TemplatesGenerator().build(options: initialObject, final: true) { template, filePath, error in

                    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let components = NSURLComponents(url: documentDirectory, resolvingAgainstBaseURL: true) else {
                              return
                          }
                    
//                    components.scheme = "shareddocuments"
                    
                    if let sharedDocuments = components.url {
                        UIApplication.shared.open(
                            sharedDocuments,
                            options: [:],
                            completionHandler: nil)
                    }
                }
            }
        }
        
        //MARK: - Preview Action
        cell.previewClosure = { [weak self] in
            
            CoreDataManager.shared.findResumeById(objectID: objectId) { initialObject in
                
                let previewResume = PreviewResumeViewController()
                previewResume.initialObject = initialObject
                previewResume.resumeData = initialObject?.buildResume()
                
                let navigationController = UINavigationController(rootViewController: previewResume)
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.isNavigationBarHidden = true
                
                self?.present(navigationController, animated: true, completion: nil)
                
                previewResume.passData = { selectedItem in
                    CoreDataManager.shared.updateInitial(options: selectedItem, initialObject: initialObject) { _ in
                        DispatchQueue.main.async {
                            self?.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        
        //MARK: - Delete Action
        cell.deleteClosure = { [weak self] in
            
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete this resume?", preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                
                let indexToScroll = IndexPath(row: max(indexPath.row-1, 0), section: 0)
                collectionView.scrollToItem(at: indexToScroll, at: .centeredHorizontally, animated: true)
                
                CoreDataManager.shared.deleteResume(objectId: objectId) { error in
                    DispatchQueue.main.async {
                        self?.userData.remove(at: indexPath.row)
                        self?.collectionView.reloadData()
                    }
                }
            }
            
            alert.addAction(dismissAction)
            alert.addAction(confirmAction)
            self?.present(alert, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - (view.frame.width / 3.2) , height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionReusableView.identifier, for: indexPath) as! CollectionReusableView
        
        footerView.buildResume = { [weak self] in
            
            if let target = self?.popTo(AddResumeViewController.self), target == false {
                
                let addResumeVC = AddResumeViewController()
                let addResumeViewController = UINavigationController(rootViewController: addResumeVC)
                addResumeViewController.modalPresentationStyle = .overFullScreen
                addResumeViewController.modalTransitionStyle = .coverVertical
                addResumeViewController.setNavigationBarHidden(true, animated: true)
                
                self?.present(addResumeViewController, animated: true, completion: nil)
            }
        }
        
        footerView.buildResumeView = { [weak self] in
            
            if let count = self?.userData.count, count > 0 {
                if let attributes = collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath) {
                    collectionView.setContentOffset(CGPoint(x: (attributes.frame.origin.x) - collectionView.contentInset.bottom - 20, y: 0), animated: true)
                }
            }
        }
        
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width - 30 , height: collectionView.frame.height)
    }
    
}

extension HomeViewController: JobsListChildControllerDataDelegate {
    
    func jobs(count: Int, location: String?) {

        var _location = "in "
        if let location = location, !location.isEmpty {
            _location += "\(location.replacingOccurrences(of: "+", with: " ").capitalized)"
        }else{
            _location = ""
        }
        
        let jobsCountStr = "About \(count) results \(_location)".trimmingCharacters(in: .whitespacesAndNewlines)
        
        let attributedText = NSMutableAttributedString(string: "Jobs you may be interested in.", attributes: [.font : UIFont(name: Theme.SFUITextMedium, size: 15) as Any, .foregroundColor : UIColor.apTintColor as Any])
        
        let sloganAttributedText = NSAttributedString(string: "\n\(jobsCountStr)", attributes: [.font : UIFont(name: Theme.SFUITextRegular, size: 13) as Any, .foregroundColor : UIColor.apTintColor as Any ])
        
        attributedText.append(sloganAttributedText)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        attributedText.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: jobsCountStr.count))

        jobsTitleLabel.attributedText = attributedText
        
    }
    
}

extension HomeViewController : UserDataPresenterDelegate {
    
    func presentUserData(userData: [UserData]) {
        self.userData = userData
        
        let count = self.userData.count
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            
            if count > 0 {
                UIView.animate(withDuration: 0.4) {
                    self?.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
                }
            }
        }
    }
}

extension HomeViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    
        //Fix tp add resume size
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadData()
        }
    }
}
