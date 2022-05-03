//
//  UIPickerView+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 28/12/2021.
//

import UIKit

class UIDataPicker: UIPickerView {
    override init(frame: CGRect) {
        super.init(frame: frame)        
        backgroundColor = .apBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - AddResumeViewController
extension AddResumeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return ImageType.allCases.count
        case 2:
            return Fonts.allCases.count
        case 3:
            return ResumeSize.allCases.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return ImageType(rawValue: row)?.title
        case 2:
            return Fonts(rawValue: row)?.title
        case 3:
            return ResumeSize(rawValue: row)?.title
        default:
            return "--"
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            selectedItem["imageType"] = row
        case 2:
            selectedItem["fontType"] = row
        case 3:
            selectedItem["format"] = row
        default: return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if pickerView.tag == 1 {
            var label = UILabel()
            if let v = view as? UILabel { label = v }
        
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.text =  ImageType(rawValue: row)?.title
            label.textAlignment = .center
            return label
        }
        
        if pickerView.tag == 2 {
            var label = UILabel()
            if let v = view as? UILabel { label = v }
        
            if let selectedFont = Fonts(rawValue: row){
                let smFont = Theme.usedFont(with: .font(selectedFont, .regular))
                label.font = UIFont (name: smFont, size: 18)
            }
        
            label.text = Fonts(rawValue: row)?.title
            label.textAlignment = .center
            return label
        }
        
        if pickerView.tag == 3 {
            var label = UILabel()
            if let v = view as? UILabel { label = v }
        
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.text =  ResumeSize(rawValue: row)?.title
            label.textAlignment = .center
            return label
        }

        return UIView()
    }
}

//MARK: - ContactInformationsVC
extension ContactInformationsVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return _countries.count
        case 2:
            return _socialLinks.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return "\(_countries[row])"
        case 2:
            return "\(_socialLinks.keys.sorted()[row])"
        default:
            return "--"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            selectedItem["country"] = _countries[row]
        case 2:
            selectedItem["socialLink"] = _socialLinks.keys.sorted()[row]
        default: return
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
}

//MARK: - WorkExperiencesVC
extension WorkExperiencesVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return _countries.count
        case 2:
            return _months.count
        case 3:
            return _years.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return "\(_countries[row])"
        case 2:
            return "\(_months[row])"
        case 3:
            return "\(_years[row])"
        default:
            return "--"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            selectedItem["country"] = _countries[row]
        case 2:
            selectedItem["month"] = _months[row]
        case 3:
            selectedItem["year"] = _years[row]
        default: return
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
}

//MARK: - EducationVC
extension EducationVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return _countries.count
        case 2:
            return _months.count
        case 3:
            return _years.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return "\(_countries[row])"
        case 2:
            return "\(_months[row])"
        case 3:
            return "\(_years[row])"
        default:
            return "--"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            selectedItem["country"] = _countries[row]
        case 2:
            selectedItem["month"] = _months[row]
        case 3:
            selectedItem["year"] = _years[row]
        default: return
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
}

//MARK: - CertificationsVC
extension CertificationsVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return _months.count
        case 2:
            return _years.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return "\(_months[row])"
        case 2:
            return "\(_years[row])"
        default:
            return "--"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            selectedItem["month"] = _months[row]
        case 2:
            selectedItem["year"] = _years[row]
        default: return
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
}

//MARK: - PreviewResumeViewController
extension PreviewResumeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return ImageType.allCases.count
        case 2:
            return Fonts.allCases.count
        case 3:
            return ResumeSize.allCases.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return ImageType(rawValue: row)?.title
        case 2:
            return Fonts(rawValue: row)?.title
        case 3:
            return ResumeSize(rawValue: row)?.title
        default:
            return "--"
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            selectedItem["imageType"] = row
        case 2:
            selectedItem["fontType"] = row
        case 3:
            selectedItem["format"] = row
        default: return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if pickerView.tag == 1 {
            var label = UILabel()
            if let v = view as? UILabel { label = v }
        
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.text =  ImageType(rawValue: row)?.title
            label.textAlignment = .center
            return label
        }
        
        if pickerView.tag == 2 {
            var label = UILabel()
            if let v = view as? UILabel { label = v }
        
            if let selectedFont = Fonts(rawValue: row){
                let smFont = Theme.usedFont(with: .font(selectedFont, .regular))
                label.font = UIFont (name: smFont, size: 18)
            }
        
            label.text = Fonts(rawValue: row)?.title
            label.textAlignment = .center
            return label
        }
        
        if pickerView.tag == 3 {
            var label = UILabel()
            if let v = view as? UILabel { label = v }
        
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.text =  ResumeSize(rawValue: row)?.title
            label.textAlignment = .center
            return label
        }

        return UIView()
    }
}

//MARK: - SettingsViewController
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return _languagesData.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return "\(_languagesData[row])"
        default:
            return "--"
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            selectedItem["language"] = _languagesData[row]
        default: return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
}
