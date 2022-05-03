//
//  TemplatesGenerator.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 5/3/2022.
//

import UIKit

class TemplatesGenerator {
    
    var template: Int
    var imageType: ImageType
    var resumeFont: Fonts
    var resumeSize: ResumeSize
    var templateColor: TemplatesColors
    
    var resumeData: ResumeData?
    
    var filePath: URL?
    var fileIdentifier: UUID?
    var fileName: String?

    init(template: Int = 0,
         imageType: ImageType = .square,
         resumeFont: Fonts = .PTSans,
         resumeSize: ResumeSize = .A4,
         templateColor: TemplatesColors = .HippiePink,
         resumeData: ResumeData? = nil ){
        
        self.template = template
        self.imageType = imageType
        self.resumeFont = resumeFont
        self.resumeSize = resumeSize
        self.templateColor = templateColor
        
        self.resumeData = resumeData
    }
    

    func build(options initialObject: Initial? = nil, final: Bool = false, completion: (UIView?, URL?, Error?)->() ) {
        
        var choosedTemplate: Templates!
        var template: UIView!
        
        if let initialObject = initialObject {
            
            let colorIndex = Int(initialObject.color)
            self.templateColor = Theme.TemplatesOptions.Templates.Colors(rawValue: colorIndex) ?? .HippiePink
            
            let fontIndex = Int(initialObject.font)
            self.resumeFont = Fonts(rawValue: fontIndex) ?? .PTSans
            
            let imagetypeIndex = Int(initialObject.imageType)
            self.imageType = ImageType(rawValue: imagetypeIndex) ?? .square
            
            let resumeSizeIndex = Int(initialObject.format)
            self.resumeSize = ResumeSize(rawValue: resumeSizeIndex) ?? .A4
            
            self.template = Int(initialObject.template)
            
            self.resumeData = initialObject.buildResume()
            
            fileIdentifier = initialObject.identifier
            
            if let contactInformations = initialObject.contactInformations?.allObjects.first as? ContactInformations {
                
                let firstName = contactInformations.firstName ?? ""
                let lastName = contactInformations.lastName ?? ""
                
                fileName = "\(firstName.capitalized) \(lastName.capitalized)".trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "-")
                
                if fileName?.isEmpty == true {
                    fileName = fileIdentifier?.uuidString
                }
                
                if let options = UserDefaults.standard.object(forKey: AppConfig.appKeys._SettingsKey) as? [String : Any],
                   let language = options["language"], language as! String != "English" {
                    fileName! += "-\(language)"
                }
            }
        }
        
        switch self.template {
        case 0:
            choosedTemplate = Templates.Cascade(size: resumeSize, imageType: self.imageType, font: self.resumeFont, colorOptions: self.templateColor, data: self.resumeData)
        case 1:
            choosedTemplate = Templates.Enfold(size: resumeSize, imageType: imageType, font: self.resumeFont, colorOptions: self.templateColor, data: self.resumeData)
        default:
            choosedTemplate = Templates.Cascade(size: resumeSize, imageType: imageType, font: self.resumeFont, colorOptions: self.templateColor, data: self.resumeData)
        }
        
        //Update Template
        template = usedTemplate(template: choosedTemplate, isScrollEnabled: true)
        
        //Generate PDF
        if let fileName = fileName, final == true {
                        
            let fileName = "Resume-\(fileName)"
            
            if let template = template as? CascadeTemplate {
                template.createResume(filename: fileName) { _url, _error in
                    completion(template, _url, _error)
                }
            }
            
            if let template = template as? EnfoldTemplate {
                template.createResume(filename: fileName) { _url, _error in
                    completion(template, _url, _error)
                }
            }
            
        }else{
            completion(template, nil, nil)
        }
    }
}
