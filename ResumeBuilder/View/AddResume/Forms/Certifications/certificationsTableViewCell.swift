//
//  certificationsTableViewCell.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 3/2/2022.
//


import UIKit
import CoreData

enum CertificationsAccessibilityLabel: CustomStringConvertible {
    case month
    case year
    
    var description: String {
        switch self {
        case .month:
            return "month-dropdown"
        case .year:
            return "year-dropdown"
        }
    }
}

class certificationsTableViewCell: UITableViewCell, UITextFieldDelegate {

    static var cellId = "skillCell"
    var keyboardReturnTapped: (()->())?
    var objectId: NSManagedObjectID? = nil
    
    var didSelectMonthTapped: ((UIButton)->())?
    var didSelectYearTapped: ((UIButton)->())?

    override var tag: Int {
        didSet{
            MonthOptionMenu.tag = tag
            YearOptionMenu.tag = tag
        }
    }
    
    let _months: [String] = DateFormatter().monthSymbols.map({ $0.capitalized })
    let _currentYear = Calendar.current.component(.year, from: Date())
    lazy var _years = (1900..._currentYear).map { String($0) }

    var certification: Certifications? {
        didSet {
            guard let certification = certification else { return }
            certificationTitleTextField.text = certification.title
            
            
            let certifDate = certification.date
            let date = formatRSDate(date: certifDate, format: "MM.yyyy").components(separatedBy: ".")
            
            //Month
            let _monthIndex = Int(date[0]) ?? 1
            let selectedMonth = _months[_monthIndex-1]
        
            let monthAttributes = NSMutableAttributedString(string: selectedMonth, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 15) as Any, .foregroundColor: UIColor.apTintColor ])
            MonthOptionMenu.setAttributedTitle(monthAttributes, for: .normal)
                        
            //Year
            let selectedYear = date.first?.lowercased() == "present" ? "\(_currentYear)" : date[1]
            
            let yearAtributes = NSMutableAttributedString(string: selectedYear, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor ])
            YearOptionMenu.setAttributedTitle(yearAtributes, for: .normal)

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardReturnTapped?()
        return false
    }

    //MARK: - Init Subviews
    lazy var certificationTitleTextField: customFormField = {
        let textField = customFormField(LCtitle: "Certified Commercial Investment Member (CCIM)", border: false)
        textField.accessibilityLabel = "certification-textfield"
        textField.clearButtonMode = .never
        textField.delegate = self
        return textField
    }()
    
    lazy var MonthOptionMenu: dropDownButton = {
        let button = dropDownButton(title: "Month", border: false)
        button.accessibilityLabel = "month-dropdown"
        button.addTarget(self, action: #selector(didSelectMonth), for: .touchUpInside)
        return button
    }()
    
    lazy var YearOptionMenu: dropDownButton = {
        let button = dropDownButton(title: "Year", border: false)
        button.accessibilityLabel = "year-dropdown"
        button.addTarget(self, action: #selector(didSelectYear), for: .touchUpInside)
        return button
    }()
    
    @objc func didSelectMonth(_ sender: UIButton){
        didSelectMonthTapped?(sender)
    }
    
    @objc func didSelectYear(_ sender: UIButton){
        didSelectYearTapped?(sender)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                    
        backgroundColor = .apBackground
        selectionStyle = .none
        
        separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
                
        accessibilityLabel = "Certification-Cell"
            
        contentView.addSubview(certificationTitleTextField)
        contentView.addSubview(MonthOptionMenu)
        contentView.addSubview(YearOptionMenu)

        NSLayoutConstraint.activate([

            certificationTitleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            certificationTitleTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            certificationTitleTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
            
            MonthOptionMenu.bottomAnchor.constraint(equalTo: certificationTitleTextField.bottomAnchor),
            MonthOptionMenu.leadingAnchor.constraint(equalTo: certificationTitleTextField.trailingAnchor, constant: 6),
            MonthOptionMenu.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),

            YearOptionMenu.bottomAnchor.constraint(equalTo: certificationTitleTextField.bottomAnchor),
            YearOptionMenu.leadingAnchor.constraint(equalTo: MonthOptionMenu.trailingAnchor, constant: 6),
            YearOptionMenu.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),

        ])

    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
