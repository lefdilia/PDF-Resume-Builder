//
//  ApplyViewController.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 11/11/2021.
//

import UIKit


class ApplyViewController: UIViewController {
    
    var job: Job? {
        didSet{
            
            guard let job = job else { return }
            
            //Set Link
            applylink = job.applylink
            
            //Job Title
            jobTitleLabel.attributedText = NSAttributedString(string: job.title,attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 18) as Any,.foregroundColor : UIColor.apTintColor])
            
            //Source Image
            //job->Company.logo? || job.source.infos.1
            let image = UIImage(named: job.company.logo ?? "company_logo")?.withInset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)).imageWithSize(CGSize(width: 60, height: 60))
            companyImageView.image = image
            
            //Location
            let attachment = NSTextAttachment()
            attachment.image = UIImage(systemName: "location.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .small))?.withTintColor(.apTintColor)
            
            let attrString = NSMutableAttributedString(attachment: attachment)
            let labelAttributes = NSMutableAttributedString(string: job.location,attributes: [
                .font : UIFont(name: Theme.nunitoSansSemiBold, size: 15) as Any,
                .foregroundColor : UIColor.apTintColor])
            attrString.append(labelAttributes)
            jobLocationLabel.attributedText = attrString
            
            //Job Type
            let attributedTitle = NSAttributedString(string: job.type.rawValue, attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 15) as Any, .foregroundColor: UIColor.white ])
            jobTypeButtonOff.setAttributedTitle(attributedTitle, for: .normal)
            
            //Job Details
            var jobDetails = job.jobDetails.withoutHtml.trimmingCharacters(in: .whitespacesAndNewlines)
            jobDetails.removeAll(where: {$0.isPunctuation})
            jobDescription.backgroundColor = .clear
            jobDescription.attributedText = NSAttributedString(string: jobDetails.firstCapitalized, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 15) as Any,.foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8)])
            
            //CompanyName Label
            companyNameLabel.attributedText = NSAttributedString(string: job.company.name ,attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 17) as Any,.foregroundColor : UIColor.apTintColor])

            if job.extraInfos.count == 0 {
                companyDetailsLabel.isHidden = true
            }
            
            for (_, _value) in job.extraInfos.enumerated() {
                let tempInfos: UILabel = {
                    let label = UILabel()
                    let titleAttributedText = NSMutableAttributedString(string: "\(_value.key.capitalized)\n", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 16) as Any,.foregroundColor : UIColor.apTintColor])
                    let infoAttributedText = NSAttributedString(string: "\(_value.value )\n", attributes: [.font : UIFont(name: Theme.nunitoSansRegular, size: 15) as Any,.foregroundColor : UIColor.apTintColor.withAlphaComponent(0.8)])
                    titleAttributedText.append(infoAttributedText)
                    label.attributedText = titleAttributedText
                    label.numberOfLines = 0
                    label.lineBreakMode = .byWordWrapping
                    label.translatesAutoresizingMaskIntoConstraints = false
                    return label
                }()
                
                companyStackView.addArrangedSubview(tempInfos)
            }
        }
    }
    
    
    var applylink: URL?
    var topAnchorConstraint: NSLayoutConstraint!
    
    @objc func didApplyJob() {
        guard let applylink = applylink else {return}
        UIApplication.shared.open(applylink)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Setup View & Blur
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let applyView: UIView = {
        let applyView = UIView()
        applyView.backgroundColor = .apBackground
        applyView.layer.cornerRadius = 15
        applyView.layer.borderWidth = 1
        applyView.layer.borderColor = UIColor.alto.cgColor
        applyView.translatesAutoresizingMaskIntoConstraints = false
        return applyView
    }()
    
    let topMenu: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "top-menu-d")?.withRenderingMode(.alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let headerView: UIView = {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    //MARK: - Setup Components
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "company_logo")?
            .withRenderingMode(.alwaysOriginal)
            .withInset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
            .imageWithSize(CGSize(width: 60, height: 60))
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = UIColor.alto.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let jobTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let jobLocationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let jobTypeButtonOff: UIButton = {
        let button = UIButton()
        button.backgroundColor = .tundora.withAlphaComponent(0.7)
        button.layer.cornerRadius = 3
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let aboutTheJobLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "About The Job",attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 18) as Any,.foregroundColor : UIColor.apTintColor])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobDescription: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let companyDetailsLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Company Details",attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 18) as Any,.foregroundColor : UIColor.apTintColor])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var companyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var applyBottomButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .apApplyOnSite
        let attributedTitle = NSAttributedString(string: "Apply On Company Site", attributes: [.font : UIFont(name: Theme.nunitoSansBold, size: 16) as Any, .foregroundColor: UIColor.white ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(didApplyJob), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        topMenu.image = UIImage(named: "top-menu-d")?.withRenderingMode(.alwaysOriginal)
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.clear
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanView(_:))))
        
        //MARK: - Setup Blured Background
        let blurBgView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurBgView.alpha = 0.95
        blurBgView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurBgView, at: 0)
        
        topAnchorConstraint = blurBgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            topAnchorConstraint,
            blurBgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurBgView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurBgView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        //MARK: - Setup applyView
        view.addSubview(applyView)
        headerView.addSubview(topMenu)
        applyView.addSubview(headerView)
        applyView.addSubview(scrollView)
        
        let _ = [
            companyImageView,
            companyNameLabel,
            jobTitleLabel,
            jobLocationLabel,
            jobTypeButtonOff,
            aboutTheJobLabel,
            jobDescription,
            companyStackView,
            applyBottomButton
        ].map{scrollView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            
            applyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            applyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            applyView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            applyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: applyView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: applyView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: applyView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 35),
            
            topMenu.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            topMenu.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: applyView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: applyView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: applyView.safeAreaLayoutGuide.bottomAnchor),
            
            companyImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 21),
            companyImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 19),
            companyImageView.heightAnchor.constraint(equalToConstant: 60),
            companyImageView.widthAnchor.constraint(equalToConstant: 60),
            
            companyNameLabel.centerYAnchor.constraint(equalTo: companyImageView.centerYAnchor),
            companyNameLabel.leadingAnchor.constraint(equalTo: companyImageView.trailingAnchor, constant: 10),
            companyNameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            
            jobTitleLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor, constant: 10),
            jobTitleLabel.leadingAnchor.constraint(equalTo: companyImageView.leadingAnchor, constant: 4),
            jobTitleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            
            jobLocationLabel.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 15),
            jobLocationLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            jobLocationLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            
            jobTypeButtonOff.topAnchor.constraint(equalTo: jobLocationLabel.bottomAnchor),
            jobTypeButtonOff.trailingAnchor.constraint(equalTo: applyView.trailingAnchor, constant: -20),
            jobTypeButtonOff.widthAnchor.constraint(equalToConstant: 80),
            
            aboutTheJobLabel.topAnchor.constraint(equalTo: jobLocationLabel.bottomAnchor, constant: 32),
            aboutTheJobLabel.leadingAnchor.constraint(equalTo: jobLocationLabel.leadingAnchor),
            
            jobDescription.topAnchor.constraint(equalTo: aboutTheJobLabel.bottomAnchor, constant: 5),
            jobDescription.leadingAnchor.constraint(equalTo: aboutTheJobLabel.leadingAnchor),
            jobDescription.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            
            companyStackView.topAnchor.constraint(equalTo: jobDescription.bottomAnchor, constant: 15),
            companyStackView.leadingAnchor.constraint(equalTo: jobDescription.leadingAnchor, constant: 10),
            companyStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            
            //Last Component
            applyBottomButton.topAnchor.constraint(equalTo: companyStackView.bottomAnchor, constant: 40),
            applyBottomButton.widthAnchor.constraint(equalToConstant: 270),
            applyBottomButton.heightAnchor.constraint(equalToConstant: 40),
            applyBottomButton.centerXAnchor.constraint(equalTo: applyView.centerXAnchor),
            
            // to Fix scrollView Height
            scrollView.bottomAnchor.constraint(equalTo: applyBottomButton.bottomAnchor, constant: 30)
        ])
    }
    
    
    @objc func didPanView(_ gesture: UIPanGestureRecognizer){
         
        if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            topAnchorConstraint.constant = -abs(translation.y)
            
            if translation.y < 0 {
                self.view.transform = .identity
            }else{
                self.view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        }else if gesture.state == .ended {
            topAnchorConstraint.constant = 0
            let translation = gesture.translation(in: self.view)
            
            let velocity = gesture.velocity(in: self.view)
            if translation.y > 10 || velocity.y > 600 {
                UIView.animate(withDuration: 0.3) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

