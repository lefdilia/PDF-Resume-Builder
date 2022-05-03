//
//  JobsListTableViewCell.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 9/11/2021.
//

import UIKit



class JobsListTableViewCell: UITableViewCell {
    
    static var cellId = "tableViewCellId"
    
    var job: Job? {
        didSet {
            
            guard let job = job else { return }
            let company = job.company
            
            //Source Image
            let image = UIImage(named: job.source.infos.1)?.imageWithSize(CGSize(width: 45, height: 45))
            sourceView.image = image
            
            //Job Tile
            jobTitleLabel.attributedText = NSAttributedString(string: job.title, attributes: [
                .font : UIFont(name: Theme.nunitoSansBold, size: 16) as Any,
                .foregroundColor: UIColor.apTintColor.withAlphaComponent(0.9)])
            
            //Company Name
            companyNameLabel.attributedText = NSAttributedString(string: company.name , attributes: [
                .font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any,
                .foregroundColor: UIColor.apTintColor.withAlphaComponent(0.6)])
            
            //Job Location
            let location =  job.location.capitalized
            jobLocationLabel.attributedText = NSAttributedString(string: location, attributes: [
                .font : UIFont(name: Theme.nunitoSansRegular, size: 14) as Any,
                .foregroundColor: UIColor.apTintColor.withAlphaComponent(0.6)])

        }
    }
    
    let sourceView: UIImageView = {
        let sourceView = UIImageView()
        sourceView.backgroundColor = UIColor.apJobCellImageBackground
        sourceView.contentMode = .scaleAspectFit
        sourceView.layer.cornerRadius = 3
        sourceView.layer.masksToBounds = true
        sourceView.clipsToBounds = true
        sourceView.translatesAutoresizingMaskIntoConstraints = false
        return sourceView
    }()
    
    let jobTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobLocationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var globalView: UIView = {
        let cellView = UIView()
        cellView.layer.masksToBounds = true
        cellView.layer.cornerRadius = 6
        cellView.layer.borderWidth = 0.6
        cellView.layer.borderColor = UIColor.apBorderJobCell.cgColor
        cellView.translatesAutoresizingMaskIntoConstraints = false
        return cellView
    }()
    
    lazy var spacingUiview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        globalView.layer.borderColor = UIColor.apBorderJobCell.cgColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .apBackground
    
        accessoryView = UIImageView(image: UIImage(named: "arrow-right")?.withTintColor(.apTintColor, renderingMode: .alwaysOriginal))
        selectionStyle = .none
        
        addSubview(globalView)
        addSubview(spacingUiview)
        
        globalView.addSubview(sourceView)
        globalView.addSubview(jobTitleLabel)
        globalView.addSubview(companyNameLabel)
        globalView.addSubview(jobLocationLabel)

        NSLayoutConstraint.activate([
            
            globalView.topAnchor.constraint(equalTo: topAnchor),
            globalView.leadingAnchor.constraint(equalTo: leadingAnchor),
            globalView.trailingAnchor.constraint(equalTo: trailingAnchor),
            globalView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),

            sourceView.leadingAnchor.constraint(equalTo: globalView.leadingAnchor, constant: 11),
            sourceView.centerYAnchor.constraint(equalTo: globalView.centerYAnchor),
            sourceView.widthAnchor.constraint(equalToConstant: 60),

            jobTitleLabel.bottomAnchor.constraint(equalTo: companyNameLabel.topAnchor, constant: -5),
            jobTitleLabel.leadingAnchor.constraint(equalTo: sourceView.trailingAnchor, constant: 9),
            jobTitleLabel.widthAnchor.constraint(equalTo: globalView.widthAnchor, multiplier: 0.7),

            companyNameLabel.centerYAnchor.constraint(equalTo: globalView.centerYAnchor),
            companyNameLabel.leadingAnchor.constraint(equalTo: jobTitleLabel.leadingAnchor),
            companyNameLabel.widthAnchor.constraint(equalTo: globalView.widthAnchor, multiplier: 0.7),

            jobLocationLabel.leadingAnchor.constraint(equalTo: jobTitleLabel.leadingAnchor),
            jobLocationLabel.bottomAnchor.constraint(equalTo: globalView.bottomAnchor, constant: -8),
            
        ])
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
