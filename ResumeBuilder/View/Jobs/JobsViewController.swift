//
//  JobsViewController.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 5/11/2021.
//

import UIKit


class JobsViewController: UIViewController {
    
    let jobListChildController = JobsListChildController()
    
    let topTitleLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSAttributedString(string: "Jobs you may be interested in.", attributes: [.font : UIFont(name: Theme.SFUITextMedium, size: 15) as Any, .foregroundColor : UIColor.apTintColor as Any])
        label.attributedText = attributedText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .apBackground
        navigationItem.title = "Jobs"
        
        jobListChildController.data = self

        //MARK: - Setup Title & filter & add childController

        view.addSubview(topTitleLabel)
        
        addChild(jobListChildController)
        view.addSubview(jobListChildController.view)
        didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            topTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            topTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),

            jobListChildController.view.topAnchor.constraint(equalTo: topTitleLabel.bottomAnchor, constant: 10),
            jobListChildController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            jobListChildController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            jobListChildController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}


extension JobsViewController: JobsListChildControllerDataDelegate {
    
    func jobs(count: Int, location: String?) {
        
        var _location = "in "
        if let location = location, !location.isEmpty {
            _location += "\(location.replacingOccurrences(of: "+", with: " ").capitalized)"
        }else{
            _location = ""
        }
       
        let title = "\(count) Job\(count>1 ? "s" : "") found \(_location)".trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        let attributedText = NSMutableAttributedString(string: "Jobs you may be interested in.", attributes: [.font : UIFont(name: Theme.SFUITextMedium, size: 15) as Any, .foregroundColor : UIColor.apTintColor as Any])
        let sloganAttributedText = NSAttributedString(string: "\n\(title)", attributes: [.font : UIFont(name: Theme.SFUITextRegular, size: 13) as Any, .foregroundColor : UIColor.apTintColor as Any ])
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        attributedText.append(sloganAttributedText)
        attributedText.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: title.count))
        
        self.topTitleLabel.attributedText = attributedText
        
    }
    
    
}
