//
//  JobsListChildController.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 9/11/2021.
//

import UIKit

protocol JobsListChildControllerDeletgate: AnyObject {
    func tableViewDidScroll(yCoordinate: CGFloat)
}

protocol JobsListChildControllerDataDelegate: AnyObject {
    func jobs(count: Int, location: String?)
}

class JobsListChildController: UIViewController {
    
    weak var delegate: JobsListChildControllerDeletgate?
    weak var data: JobsListChildControllerDataDelegate?

    var jobsPresenter = JobsPresenter()
    var userLocationPresenter = UserLocationPresenter()
    
    var jobs = [Job]()
    var location: String?
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(JobsListTableViewCell.self, forCellReuseIdentifier: JobsListTableViewCell.cellId)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .apBackground
        table.tableFooterView = UIView()
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.contentInset.bottom = 20
        return table
    }()
    
    //MARK: - Form Fields
    
    lazy var searchJobTexField: AutocompleteField = {
        
        let textField = AutocompleteField()
        textField.placeholder = "Job Title..."
        textField.autocorrectionType = .no
        textField.font = UIFont(name: Theme.nunitoSansSemiBold, size: 15)
        textField.borderStyle = .roundedRect
        
        textField.delegate = self
        textField.tag = 0
        
        textField.backgroundColor = .apBackground
        textField.tintColor = .apTextFieldHolder
        textField.textColor = .apTextFieldTextColor
        
        textField.layer.cornerRadius = 3
        textField.layer.borderColor = UIColor.apTextFieldTextColor.cgColor
        
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.returnKeyType = .continue
        textField.keyboardType = .alphabet
        textField.setLeftView(image: UIImage(named: "search")!.withTintColor(.apTextFieldImageColor, renderingMode: .alwaysOriginal))
        
        textField.leftViewPadding = 25
        textField.autocapitalizationType = .words
        textField.suggestions = jobSuggestions
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var locationTexField: AutocompleteField = {
        
        let textField = AutocompleteField()
        textField.placeholder = "Location..."
        textField.autocorrectionType = .no
        textField.font = UIFont(name: Theme.nunitoSansRegular, size: 14)
        textField.borderStyle = .roundedRect
        
        textField.delegate = self
        textField.tag = 1
        
        textField.backgroundColor = .apBackground
        textField.tintColor = .apTextFieldHolder
        textField.textColor = .apTextFieldTextColor
        
        textField.layer.cornerRadius = 3
        textField.layer.borderColor = UIColor.apTextFieldTextColor.cgColor

        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.returnKeyType = .search
        textField.keyboardType = .alphabet
        
        //Autocomplete Fix
        textField.leftViewMode = .always
        textField.leftViewPadding = 35

        textField.autocapitalizationType = .words
        textField.suggestions = locationSuggestions
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .apLocationBackground
        button.addTarget(self, action: #selector(didRequestLocation), for: .touchUpInside)
        button.setImage(UIImage(named: "location")?.withTintColor(.apBrandyRose, renderingMode: .alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Build Empty Jobs level (Embed in a stackView)

    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nojobs")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var initMessageLabel: UILabel = {
       let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "What position are you looking for?\n", attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 18) as Any, .foregroundColor : UIColor.apTintColorLight as Any])
        attributedText.append(NSAttributedString(string: "Find the right fit.\n", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 16) as Any, .foregroundColor : UIColor.apTintColorLight as Any]))
        
        attributedText.append(NSAttributedString(string: "\nExample : ", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 16) as Any, .foregroundColor : UIColor.apTintColorLight as Any]))

        var suggestions = jobSuggestions.map ({ " \($0) " }).joined(separator: "  - ")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
    
        attributedText.append(NSAttributedString(string: "\(suggestions)", attributes: [.font : UIFont(name: Theme.RubikItalic, size: 15) as Any, .foregroundColor : UIColor.apTintColorLight as Any]))
        
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedText.length))

        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageLabel: UILabel = {
       let label = UILabel()
        let attributedText = NSAttributedString(string: "We're sorry we couldn't find any jobs for the below search.", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 17) as Any, .foregroundColor : UIColor.apTintColorLight as Any])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let messageTopTipsLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Find more relevant jobs with these search tips :\n", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 16) as Any, .foregroundColor : UIColor.apTintColorLight as Any])
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageTipsLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 15) as Any, .foregroundColor : UIColor.apTintColorLight as Any])
        
        let tips = [ "Check your job title and location to ensure that they are correct",
                     "Improve your results by expanding your search area.",
                     "Avoid abbreviations in your search."]
        
        let circleAttachement = NSTextAttachment()
        circleAttachement.image = UIImage(named: "circle")?.withTintColor(.apDotColor, renderingMode: .alwaysTemplate)
        let imageToString = NSAttributedString(attachment: circleAttachement)

        
        for tip in tips {
            attributedText.append(imageToString)
            attributedText.append(NSAttributedString(string: " \(tip)\n ", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 15) as Any, .foregroundColor : UIColor.apTintColorLight as Any]))
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 8
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedText.length))
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var lineSepartor: UIView = {
        let line = UIView()
        line.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.backgroundColor = .apDotColor
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    lazy var arrangedMessage: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [messageImageView, messageLabel, initMessageLabel, lineSepartor, messageTopTipsLabel, messageTipsLabel])
        stack.axis = .vertical
        stack.spacing = 10.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        return stack
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
    
    lazy var scrollToTop: UIImageView = {
        let scrollView = UIImageView()
        scrollView.image = UIImage(named: "scrollToTop")?.withRenderingMode(.alwaysOriginal)
        scrollView.contentMode = .scaleAspectFit
        scrollView.isHidden = true
        scrollView.alpha = 0.5
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scrollToTopTapped)))
        scrollView.isUserInteractionEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        scrollToTop.image = UIImage(named: "scrollToTop")?.withRenderingMode(.alwaysOriginal)
    }
    
    //MARK: - Objc Functions
    @objc func scrollToTopTapped(){
        if self.jobs.isEmpty == false {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @objc func didRequestLocation(){
        userLocationPresenter.requetUserLocation()
    }

    //MARK: -Setup Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        locationTexField.leftView = locationButton
        locationTexField.setNeedsLayout()
        locationTexField.layoutIfNeeded()
                
        locationButton.heightAnchor.constraint(equalToConstant: locationTexField.frame.height).isActive = true
        locationButton.widthAnchor.constraint(equalToConstant: locationTexField.leftViewPadding).isActive = true
        locationButton.centerYAnchor.constraint(equalTo: locationTexField.centerYAnchor).isActive = true
        locationButton.leadingAnchor.constraint(equalTo: locationTexField.leadingAnchor).isActive = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobsPresenter.delegate = self
        userLocationPresenter.delegate = self
        
        view.backgroundColor = .apBackground
        
        //Search Form Message
        messageImageView.isHidden = false
        initMessageLabel.isHidden = false
        
        messageLabel.isHidden = true
        messageTopTipsLabel.isHidden = true
        messageTipsLabel.isHidden = true
        lineSepartor.isHidden = true

        view.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - Setup Job Search Forms
        view.addSubview(searchJobTexField)
        view.addSubview(locationTexField)

        view.addSubview(tableView)
        
        view.addSubview(activityIndicator)
        
        view.addSubview(scrollToTop)

        NSLayoutConstraint.activate([
            searchJobTexField.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            searchJobTexField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchJobTexField.heightAnchor.constraint(equalToConstant: 45),
            searchJobTexField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            locationTexField.leadingAnchor.constraint(equalTo: searchJobTexField.trailingAnchor, constant: 4),
            locationTexField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            locationTexField.centerYAnchor.constraint(equalTo: searchJobTexField.centerYAnchor),
            locationTexField.heightAnchor.constraint(equalToConstant: 45),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),

            tableView.topAnchor.constraint(equalTo: locationTexField.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollToTop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollToTop.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }

}

extension JobsListChildController: UserLocationPresenterDelegate {
    
    func presentLocation(location: Location?, _ error: Error?) {
        
        let textPosition = locationTexField.beginningOfDocument
        guard let location = location, error == nil else {
            locationButton.setImage(UIImage(named: "no-location")?.withTintColor(.brandyRose, renderingMode: .alwaysOriginal), for: .normal)
            locationTexField.becomeFirstResponder()
            return
        }
        locationButton.setImage(UIImage(named: "location")?.withTintColor(.brandyRose, renderingMode: .alwaysOriginal), for: .normal)

        locationTexField.text = "\(location.country)"
        locationTexField.selectedTextRange = locationTexField.textRange(from: textPosition, to: textPosition)
    }
}

extension JobsListChildController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                        
        let textField = textField as! AutocompleteField
        textField.text = textField.suggestion
        
        tagBasedTextField(textField) {
            let keyword = searchJobTexField.text
            let location = locationTexField.text
            
            let filters = JobSearchFilters(keyword: keyword, location: location)
            jobsPresenter.fetchJobs(filters: filters)
            
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


extension JobsListChildController: JobsPresenterProtocol {
    
    func presentWaitStatus() {
        activityIndicator.startAnimating()
        self.arrangedMessage.isHidden = true
        
        //disable Textfield
        locationTexField.isEnabled = false
        searchJobTexField.isEnabled = false
    }
    
    func presentJobs(jobs: [Job], location: String?) {
        
        self.jobs = jobs
        self.location = location
        
        activityIndicator.stopAnimating()
        //Enable Textfield
        locationTexField.isEnabled = true
        searchJobTexField.isEnabled = true
        
        data?.jobs(count: jobs.count, location: location)
        DispatchQueue.main.async { [weak self] in
            
            self?.tableView.reloadData()
            self?.arrangedMessage.isHidden = false
            
            self?.initMessageLabel.isHidden = true
            self?.messageImageView.isHidden = false
            self?.messageLabel.isHidden = false
            self?.messageTopTipsLabel.isHidden = false
            self?.messageTipsLabel.isHidden = false
            self?.lineSepartor.isHidden = false
        
            if self?.jobs.isEmpty == false {
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            
        }
    }
}

extension JobsListChildController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
                
        let messageView = UIView()
        messageView.addSubview(arrangedMessage)
                
        NSLayoutConstraint.activate([
            
            arrangedMessage.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10),
            arrangedMessage.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            arrangedMessage.widthAnchor.constraint(equalTo: messageView.widthAnchor, multiplier: 0.95),
        ])
        
        return messageView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return jobs.count == 0 ? 300 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobsListTableViewCell.cellId, for: indexPath) as! JobsListTableViewCell
        cell.job = jobs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
        let applyModal = ApplyViewController()
        
        applyModal.job = self.jobs[indexPath.row]
        
        applyModal.modalPresentationStyle = .overFullScreen
        applyModal.modalTransitionStyle = .coverVertical
        
        self.present(applyModal, animated: true, completion: nil)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        
        if scrollView.contentOffset.y > 50 {
            UIView.animate(withDuration: 0.3, delay: 0.1) {
                self.scrollToTop.isHidden = false
                self.scrollToTop.alpha = 0.5
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.scrollToTop.isHidden = true
                self.scrollToTop.alpha = 0
            }
        }
        
        delegate?.tableViewDidScroll(yCoordinate: scrollView.contentOffset.y)
    }

}
