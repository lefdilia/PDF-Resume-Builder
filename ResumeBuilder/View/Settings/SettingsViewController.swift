//
//  SettingsViewController.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 5/11/2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let _languagesData = AppConfig.appData.languages
    var _languagesPickerView = UIDataPicker()
    
    lazy var tempTextView = UITextField(frame: .zero)
    lazy var selectedItem: [String: Any] = UserDefaults.standard.object(forKey: AppConfig.appKeys._SettingsKey) as? [String : Any] ?? AppConfig.appKeys._SettingsDefault
    
    lazy var settings = [Section]()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .singleLine
        table.separatorInset = .zero
        table.layoutMargins = .zero
        
        table.backgroundColor = .apSettingsBackground

        table.register(SwitchSettingsCell.self, forCellReuseIdentifier: SwitchSettingsCell.cellId)
        table.register(StaticSettingsCell.self, forCellReuseIdentifier: StaticSettingsCell.cellId)
        
        return table
    }()
    
    lazy var doneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        toolbar.backgroundColor = .apBackground

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .apTintColor
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(UIColor.apTintColor, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(closeButtonTapped))
        
        let items = [closeButton, flexSpace, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()
        
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .apSettingsBackground
        
        navigationItem.title = "Settings"
        
        self.settings = fetchSettings()
        
        view.addSubview(tempTextView)
        view.addSubview(tableView)
        
        tempTextView.inputView = _languagesPickerView
        tempTextView.inputAccessoryView = doneToolbar
        
        _languagesPickerView.dataSource = self
        _languagesPickerView.delegate = self
        _languagesPickerView.tag = 1
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func didTapOnPortfolioFooter(){
        didTapOnPortfolio()
    }
    
    @objc func closeButtonTapped(){
        
        //Fix: Wheel Picking unsaved option
        if let _selectedItem = UserDefaults.standard.object(forKey: AppConfig.appKeys._SettingsKey) as? [String : Any] {
            self.selectedItem = _selectedItem
            
            if let _selectedValueindex = AppConfig.appData.languages.firstIndex(of: self.selectedItem["language"] as! String) {
                let _index = _selectedValueindex
                self._languagesPickerView.selectRow(_index, inComponent: 0, animated: true)
            }
        }
        tempTextView.resignFirstResponder()
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem){
        
        UserDefaults.standard.setValue(selectedItem, forKey: "Settings")
        
        self.settings = fetchSettings()
        self.tableView.reloadData()
        
        closeButtonTapped()
    }
    
    func didTapOnPortfolio(_ link: SettingLinks? = .portfolio){
        if let link = link, let portfolio = URL(string: link.rawValue) {
            UIApplication.shared.open(portfolio)
        }
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].options.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = settings[section].title
        
        let headerView: UIView = {
            let _view = UIView()
            return _view
        }()
        
        let headerLabel: UILabel = {
            let label = UILabel()
            let attributedText = NSMutableAttributedString(string: title, attributes: [
                .font : UIFont.systemFont(ofSize: 15, weight: .bold) as Any,
                .foregroundColor : UIColor.apTintColor as Any ])
            label.attributedText = attributedText
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -9)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let _appName = Bundle.main.appDisplayName ?? "--"
        let _appVersion = Bundle.main.appVersion ?? "--"
        let _buildNumber = Bundle.main.buildNumber ?? "0.0.0"
        
        let sdFooter = "\(_appName) - Version \(_appVersion) (Build \(_buildNumber))"
        
        let footerView: UIView = {
            let _view = UIView()
            _view.isUserInteractionEnabled = true
            _view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnPortfolioFooter)))
            return _view
        }()
        
        let footerLabel: UILabel = {
            let label = UILabel()
            
            let usedColor: UIColor = .apTintColor
            
            let attributedText = NSMutableAttributedString(string: "Made with ", attributes: [ .font : UIFont.systemFont(ofSize: 14, weight: .regular) as Any,.foregroundColor : usedColor as Any ])
            
            let heartAttachment = NSTextAttachment()
            heartAttachment.image = UIImage(named: "heart-footer")
            heartAttachment.bounds = CGRect(x: 0, y: label.font.descender - 4, width: heartAttachment.image!.size.width, height: heartAttachment.image!.size.height)
            attributedText.append(NSAttributedString(attachment: heartAttachment))
            
            attributedText.append(NSAttributedString(string: " & ", attributes: [ .font : UIFont.systemFont(ofSize: 15, weight: .regular) as Any,.foregroundColor : usedColor as Any ]))
            
            let caffeAttachment = NSTextAttachment()
            caffeAttachment.image = UIImage(named: "coffee")
            caffeAttachment.bounds = CGRect(x: 0, y: label.font.descender - 1, width: caffeAttachment.image!.size.width, height: caffeAttachment.image!.size.height)
            attributedText.append(NSAttributedString(attachment: caffeAttachment))
            
            attributedText.append(NSAttributedString(string: " By ", attributes: [ .font : UIFont.systemFont(ofSize: 14, weight: .regular) as Any,.foregroundColor : usedColor as Any ]))
            attributedText.append(NSAttributedString(string: "Lefdilia", attributes: [ .font : UIFont.systemFont(ofSize: 14, weight: .bold) as Any,.foregroundColor : usedColor as Any ]))
            
            attributedText.append(NSAttributedString(string: "\n\(sdFooter)", attributes: [ .font : UIFont.systemFont(ofSize: 11, weight: .regular) as Any,.foregroundColor : usedColor as Any ]))
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            attributedText.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: sdFooter.count))
            
            label.attributedText = attributedText
            label.textAlignment = .center
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        footerView.addSubview(footerLabel)
        
        NSLayoutConstraint.activate([
            footerView.heightAnchor.constraint(equalToConstant: 100),
            footerLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            footerLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor)
        ])
        
        if section ==  tableView.numberOfSections - 1 {
            return footerView
        }else{
            return UIView()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 10
        }else{
            return 62
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let type = settings[indexPath.section].options[indexPath.row]
        
        switch type.self {
        case .staticOptions(model: let modelSetting):
            modelSetting.handler()
        case .switchOptions(model: let modelSetting):
            modelSetting.handler()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let setting = settings[indexPath.section].options[indexPath.row]
        
        switch setting.self {
            
        case .staticOptions(model: let settingModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StaticSettingsCell.cellId, for: indexPath) as? StaticSettingsCell else {
                return UITableViewCell()
            }
            cell._setting = settingModel
            return cell
        case .switchOptions(model: let settingModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchSettingsCell.cellId, for: indexPath) as? SwitchSettingsCell else {
                return UITableViewCell()
            }
            
            cell._setting = settingModel
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    private func fetchSettings() -> [Section] {
        
        let settingsOptions: [String: Any] = UserDefaults.standard.object(forKey: AppConfig.appKeys._SettingsKey) as? [String : Any] ?? AppConfig.appKeys._SettingsDefault
        
        let settings = [
            Section(title: "User Options", options: [
                .switchOptions(model: SwitchSettings(title: "Resume Languages",
                                                     slogan: "Please select default resume language", icon: nil,
                                                     iconBackgroundColor: .clear, handler: { [weak self] in
                                                         
                                                         self?.tempTextView.becomeFirstResponder()
                                                         
                                                         var _index = 0
                                                         if let _selectedValueindex = AppConfig.appData.languages.firstIndex(of: self?.selectedItem["language"] as! String) {
                                                             _index = _selectedValueindex
                                                         }
                                                         self?._languagesPickerView.selectRow(_index, inComponent: 0, animated: true)
                                                     }, _values: "\(settingsOptions["language"] ?? "")"))
            ]),
            Section(title: "Policies", options: [
                .staticOptions(model: StaticSettings(title: "Terms Of Use",
                                                     slogan: "", icon:  UIImage(systemName: "link"),
                                                     iconBackgroundColor: .clear, _values: .termsAndConditions, handler: { [weak self] in
                                                         self?.didTapOnPortfolio(.termsAndConditions)
                                                     })),
                .staticOptions(model: StaticSettings(title: "Privacy Policy",
                                                     slogan: "", icon:  UIImage(systemName: "link"),
                                                     iconBackgroundColor: .clear, _values: .privacyPolicy, handler: { [weak self] in
                                                         self?.didTapOnPortfolio(.privacyPolicy)
                                                     })),
            ]),
            Section(title: "Developer", options: [
                .staticOptions(model: StaticSettings(title: "Find us",
                                                     slogan: "Connect or follow us on LinkedIn to keep updated.", icon: UIImage(named: "linkedin"),
                                                     iconBackgroundColor: .clear, _values: .linkedin, handler: { [weak self] in
                                                         self?.didTapOnPortfolio(.linkedin)
                                                     })),
            ])
        ]
        
        return settings
    }
}
