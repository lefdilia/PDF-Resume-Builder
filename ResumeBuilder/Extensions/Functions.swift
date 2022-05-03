//
//  Functions.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 25/12/2021.
//

import UIKit

//Autocomplete
let interestsSuggestions = ["Reading", "Writing", "Video Games","Space Exploration", "Football", "Mindfulness", "Artificial Intelligence", "Basketball", "Football", "Volleyball", "Marathon", "running", "Skiing", "Tennis", "Cycling", "Swimming", "Baseball", "Mountain climbing"]

let jobSuggestions = [ "Software Developer", "Accountant", "Data Scientist", "Web Developer", "Lawyer", "Java developer", "Data analyst", "Cashier", "IT", "Delivery driver", "Nurse", "Graphic designer", "Administrative assistant", "Accounting", "Engineer", "Entry level", "Healthcare", "Assistant", "Bartender"]

let locationSuggestions = [ "Austria", "Australia", "Belgium", "Brazil", "Canada", "China", "Czechia", "Denmark", "France", "Finland", "Germany", "India", "Italy", "Japan", "Mexico", "Netherlands", "New Zealand", "Norway", "Poland", "Russia", "Singapore", "United Arab Emirates", "United Kingdom", "United States", "South Africa", "Switzerland", "Spain", "Sweeden"]

let softwaresSuggestions = [ "Word", "Excel", "Outlook", "Office Suite", "Microsoft Publisher", "Powerpoint", "OneNote", "Google Sheets", "OpenOffice Calc", "Google Slides", "OpenOffice Impress", "Tableu", "MS Access", "Oracle", "Teradata", "IBM DB2", "MySQL", "SQL,Knowledge of spreadsheets", "Airtable", "Google Docs", "Microsoft Access", "NoSQL", "RDBMS", "SQL", "XML Databases", "Adobe Suite", "Desktop Publishing", "Design", "InDesign", "Sketch", "Photoshop", "Illustrator", "InDesign", "Acrobat", "Corel Draw"]

func localLanguages() -> [String] {
    var languages = [String]()
    let currentLocale = NSLocale.current as NSLocale
    for languageCode in NSLocale.availableLocaleIdentifiers {
        if let name = currentLocale.displayName(forKey: NSLocale.Key.languageCode, value: languageCode), !languages.contains(name) { languages.append(name.capitalized) }
    }
    return languages.sorted()
}

func findSubStringRanges(string: String, pattern: String = "\\[[A-Za-z0-9 ]+\\]") -> [NSRange]{
    let nsString = string as NSString
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    let matches = regex?.matches(in: string, options: .withoutAnchoringBounds, range: NSMakeRange(0, nsString.length))
    return matches?.map{$0.range} ?? []
}

func colorizedSubString(initText: String?) -> NSAttributedString? {
    guard let initText = initText else { return nil }
    
    let attributedString = NSMutableAttributedString(string: initText, attributes: [.font : UIFont(name: Theme.nunitoSansSemiBold, size: 14) as Any, .foregroundColor: UIColor.apTintColor])
    
    let ranges = findSubStringRanges(string: initText)
    for range in ranges {
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
    }
    
    return attributedString
}

func formatRSDate(date: Date?, format: String = "MMMM yyyy") -> String {
    
    guard let date = date else { return "Present" }
    
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    let dateString = formatter.string(from: date)
    return dateString.capitalized
}


func createSeparator(color : UIColor) -> UIView {
    let separator = UIView()
    separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    separator.backgroundColor = color.withAlphaComponent(0.2)
    separator.translatesAutoresizingMaskIntoConstraints = false
    return separator
}


class PlainHorizontalProgressBar: UIView {
    
    var color: UIColor = .gray
    var progress: CGFloat = 0
    let progressLayer = CALayer()
    
    required init(level progress: Int, color: UIColor) {
        
        self.color = color
        self.progress = progress == 0 ? 1/4 : CGFloat(progress)
        
        super.init(frame: .zero)
        
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayers() {
        progressLayer.removeFromSuperlayer()
        layer.addSublayer(progressLayer)
    }
    
    override func draw(_ rect: CGRect) {
        
        let rectWidth = rect.width * ( progress / 5 )
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rectWidth, height: rect.height))
        
        progressLayer.frame = progressRect
        progressLayer.backgroundColor = color.cgColor
    }
}

