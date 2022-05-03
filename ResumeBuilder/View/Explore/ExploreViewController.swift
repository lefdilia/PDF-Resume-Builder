//
//  ExploreViewController.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 5/11/2021.
//

import UIKit


class ExploreViewController: UIViewController {
    
    let userDataPresenter = UserDataPresenter()
    var userData = [UserData]()
    
    var finalizedStage: (()->())?
    
    //MARK: - Top Header (CollectionView)
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ExploreResumeListCell.self, forCellWithReuseIdentifier: ExploreResumeListCell.cellId)
        collectionView.register(ExploreCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ExploreCollectionReusableView.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .apBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userDataPresenter.getInitList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDataPresenter.delegate = self
        userDataPresenter.getInitList()
        
        view.backgroundColor = .apBackground
        navigationItem.title = "Resumes"
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
        
        finalizedStage = { [weak self] in
            self?.userDataPresenter.getInitList()
        }
    }
}

extension ExploreViewController : UserDataPresenterDelegate {
    
    func presentUserData(userData: [UserData]) {
        self.userData = userData
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let userDataCount = self.userData.count
        
        if userDataCount == 0 {
            collectionView.setEmptyMessage("No Resume Found.")
        }else{
            collectionView.restoreBgView()
        }
        
        return userDataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreResumeListCell.cellId, for: indexPath) as! ExploreResumeListCell
        
        let userData = userData[indexPath.item]
        let objectId = userData.objectID
        
        cell.userData = userData
        
        cell.editClosure = { [weak self] in

            CoreDataManager.shared.findResumeById(objectID: objectId) { initialObject in
                if let target = self?.popTo(MainSectionVC.self), target == false {
                    let mainViewController = MainSectionVC()
                    mainViewController.initialObject = initialObject
                    let _initVC = UINavigationController(rootViewController: mainViewController)
                    _initVC.modalPresentationStyle = .overFullScreen
                    _initVC.modalTransitionStyle = .coverVertical
                    _initVC.setNavigationBarHidden(true, animated: true)
                    self?.present(_initVC, animated: true, completion: nil)
                }
            }
        }
        
        //MARK: - Share Action
        cell.shareClosure = {
            
            cell.topButton.isEnabled = true // /!\ //Re-Enable button
            
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
                    
                    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                          let components = NSURLComponents(url: documentDirectory, resolvingAgainstBaseURL: true) else {
                              return
                          }
                    components.scheme = "shareddocuments"
                    
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
                previewResume.modalPresentationStyle = .fullScreen
                
                self?.present(previewResume, animated: true, completion: nil)
                
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
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width - 20 , height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ExploreCollectionReusableView.identifier, for: indexPath) as! ExploreCollectionReusableView
        
        headerView.buildResume = { [weak self] in
            
            if let target = self?.popTo(AddResumeViewController.self), target == false {
                
                let addResumeVC = AddResumeViewController()
                let addResumeViewController = UINavigationController(rootViewController: addResumeVC)
                addResumeViewController.modalPresentationStyle = .overFullScreen
                addResumeViewController.modalTransitionStyle = .coverVertical
                addResumeViewController.setNavigationBarHidden(true, animated: true)
                
                self?.present(addResumeViewController, animated: true, completion: nil)
            }
        }
        
        return headerView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width - 20 , height: 120)
    }
    
}
