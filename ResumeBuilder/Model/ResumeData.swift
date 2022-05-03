//
//  ResumeData.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 31/12/2021.
//

import UIKit
import CoreData


enum initialType: Int {
    case Resume
    case CoverLetter
}

enum ImageType: Int, CaseIterable {
    case `none` // Means Not Image
    case square
    case oval
    
    var title: String {
        switch self {
        case .none:
            return "None"
        case .square:
            return "Square"
        case .oval:
            return "Oval"
        }
    }
}

//MARK: - ResumeData
struct ResumeData {
    
    var image: UIImage?
    var firstName:String?
    var lastName:String?
    var profession:String?
    
    var summary: String?

    var sections: [SectionBlock]
    var stacks: [StackBlock]
    
    init(image: UIImage? = nil,
         firstName: String? = nil,
         lastName: String? = nil,
         profession: String? = nil,
         summary: String? = nil,
         sections: [SectionBlock],
         stacks: [StackBlock]){
        self.sections = sections
        self.stacks = stacks
        
        self.image = image
        self.firstName = firstName
        self.lastName = lastName
        self.profession = profession
        self.summary = summary

    }
    
    func buildDataPlaceHolder() -> ResumeData {
        
        let resumeTestData = ResumeData(image: UIImage(named: "photoPlaceHolder"),
                                        firstName: "Ayoub",
                                        lastName: "Lefdili Alaoui",
                                        profession: "IOS Developer",
                                        summary: "Ambitious self-taught developer, hardworking, seeking for a job with development skills. Passionate and familiar with development and deployment process for many web-based technologies, eager to secure IOS Developer to help launch career and to help team to achieve company goals.",
                                        sections: [
           SectionBlock(index: 0, section: .personalInfo,
                        infos: ["address".localized(): "134 Rightward Way - Morocco, ME, 04019",
                                                                 "phone".localized(): "774-987-4009",
                                                                 "email".localized(): "lefdilia@gmail.com",
                                                                 "Website".localized(): "https://lefdilia.com",
                                                                 "Linkedin": "@lefdilia",
                                                                 "Github": "@lefdilia",
                                                                 "Patreon": nil]),
           SectionBlock(index: 1, section: .skills, infos: ["IOS Development": 4, "Swift": 4, "CoreData": 2, "Nodejs": 3, "MYSQL": 3, "ExpressJs": 3, "Sketch": 4]),
           SectionBlock(index: 2, section: .softwares, infos: ["Microsoft Word": 4, "Microsoft Project": 3, "MS Windows Server": 2, "Linux/Unix": 4, "Microsoft Excel": 4]),
           SectionBlock(index: 3, section: .languages, infos: ["Arabic": 5, "English": 4, "French": 4, "German": 2])
                                        ],
                                        stacks: [
                                            StackBlock(index: 0, section: .workExperiences,
                                                       infos: [
                                                        (title: "Senior Project Manager", location: "Seton Hospital, ME", rangeDate: (start: "2006-12", finish: "Present"), roles: ["Lorem ipsum dolor sit amet.","Consec tetur adipiscing elit."]),
                                                        (title: "Senior Accountant", location: "Kesz Paradise, OH", rangeDate: (start:"1996-09", finish:"2001-11"), roles: ["Lorem ipsum dolor sit amet.","Consec tetur adipiscing elit."] )
                                                       ]),
                                            
                                            StackBlock(index: 1, section: .education, infos:[
                                                (title: "Harvard CS50", location: "Seton Hospital, ME", rangeDate: (start: "1996-09", finish: nil), roles: ["Lorem ipsum dolor sit amet.","Consec tetur adipiscing elit."] ),
                                                (title: "Software Linkedin developer", location: "Kesz Paradise, OH", rangeDate: (start: "2008-10", finish: nil), roles: ["Lorem ipsum dolor sit amet.","Consec tetur adipiscing elit."] ),
                                                (title: "Course Project Manager", location: "Seton Hospital, ME", rangeDate: (start: "2019-06", finish: nil), roles: ["Lorem ipsum dolor sit amet.","Consec tetur adipiscing elit."] ),
                                                (title: "Course Project Manager", location: "Kesz Paradise, OH", rangeDate: (start: "2021-06", finish: nil), roles: ["Lorem ipsum dolor sit amet.","Consec tetur adipiscing elit."] ),
                                                (title: "Course Project Manager", location: "Kesz Paradise, OH", rangeDate: (start: "2021-06", finish: nil), roles: ["Lorem ipsum dolor sit amet.","Consec tetur adipiscing elit."] )
                                            ]),
                                            
                                            StackBlock(index: 2, section: .certifications, infos:[
                                                (title: "Apple Certification", location: nil, rangeDate: (start: "1996-09", finish: nil), roles: [] ),
                                                (title: "Software Linkedin developer", location: nil, rangeDate: (start: "2008-10", finish: nil), roles: [] ),
                                                (title: "Course Project Manager", location: nil, rangeDate: (start: "2019-06", finish: nil), roles: [] ),
                                                (title: "Course Project Manager", location: nil, rangeDate: (start: "2021-06", finish: nil), roles: [] )
                                            ]),
                                            
                                                                                        StackBlock(index: 3, section: .accomplishments,
                                                                                                   infos:[
                                                                                                    (title: "", location: nil, rangeDate: (start: "", finish: nil), roles: [
                                                                                                        "Lorem ipsum dolor sit amet.",
                                                                                                        "Lorem ipsum dolor sit amet.",
                                                                                                        "Consec tetur adipiscing elit."])
                                                                                                   ]),
                                            
                                                                                        StackBlock(index: 4, section: .interests,
                                                                                                   infos:[
                                                                                                    (title: "", location: ["Lorem ipsum","Lorem ipsum","Lorem ipsum"].joined(separator: " - "), rangeDate: (start: "", finish: nil), roles: [])
                                                                                                   ]),
                                            
                                                                                        StackBlock(index: 5, section: .additionalInformation,
                                                                                                   infos:[
                                                                                                    (title: "Lorem ipsum dolor sit amet, consec tetur adipiscing elit.Lorem ipsum dolor sit amet, consec tetur adipiscing elit.Lorem ipsum dolor sit amet, consec tetur adipiscing elit.Lorem ipsum dolor sit amet, consec tetur adipiscing elit.Lorem ipsum dolor sit amet, consec tetur adipiscing elit.", location: nil, rangeDate: (start: "", finish: nil), roles: [] )
                                                                                                   ]),
                                            
                                                                                        StackBlock(index: 6, section: .customSection(title: "Custom Lorem Vlad"),
                                                                                                   infos:[
                                                                                                    (title: "Lorem ipsum dolor sit amet, consec tetur adipiscing elit.Lorem ipsum dolor sit amet, consec tetur adipiscing elit.Lorem ipsum dolor sit amet, consec tetur adipiscing elit.", location: nil, rangeDate: (start: "", finish: nil), roles: [] )
                                                                                                   ]),
                                            
                                                                                        StackBlock(index: 8, section: .customSection(title: "Extra-Section"),
                                                                                                   infos:[
                                                                                                    (title: "Lorem ipsum dolor sit amet, consec tetur adipiscing elit.Lorem ipsum dolor sit amet, consec tetur adipiscing elit.", location: nil, rangeDate: (start: "", finish: nil), roles: [] )
                                                                                                   ])
                                        ])
        
        
        return resumeTestData
    }

}

struct SectionBlock {
    let index: Int
    let section: BuiltInSection
    var infos: [String: Any?]
}

typealias builtBlock = (title: String, location: String?, rangeDate: (start:String, finish: String?), roles: [String])

struct StackBlock {
    var index: Int
    let section: BuiltInSection
    let infos: [builtBlock]
}

enum BuiltInSection: CustomStringConvertible, Equatable {
    
    case personalInfo
    case skills
    case softwares
    case languages
    
    case summary
    case workExperiences
    case education
    case certifications
    case accomplishments
    case interests
    case additionalInformation
    
    case customSection(title: String)

    var description: String {
        switch self {
            
        case .personalInfo:
            return "Personal Info".localized()
        case .skills:
            return "Skills".localized()
        case .softwares:
            return "Softwares".localized()
        case .languages:
            return "Languages".localized()
        case .summary:
            return "Summary".localized()
        case .workExperiences:
            return "Work History".localized()
        case .education:
            return "Education".localized()
        case .certifications:
            return "Certifications".localized()
        case .accomplishments:
            return "Accomplishments".localized()
        case .interests:
            return "Interests".localized()
        case .additionalInformation:
            return "Additional Information".localized()
            
        case .customSection(title: let title):
            return title
        }
    }
}


enum language: Int {
    case Native = 5
    case ProfessionalProficiency = 4
    case WorkingProficiency = 3
    case LimitedProficiency = 2
    case ElementaryProficiency = 1
    case NoProficiency = 0
    
    var level: String {
        switch self {
        case .Native:
            return "Native"
        case .ProfessionalProficiency:
            return "Proficient"
        case .WorkingProficiency:
            return "Advanced"
        case .LimitedProficiency:
            return "Intermediate"
        case .ElementaryProficiency:
            return "Beginner"
        case .NoProficiency:
            return "Novice"
        }
    }
}


enum MainSections: Equatable, CustomStringConvertible {

    case accomplishments
    case additionalInformation
    case certifications
    case contactInformations
    case customSection
    case education
    case interests
    case languages
    case skills
    case softwares
    case summary
    case workExperiences
    
    case custom(title: String? = "", slogan: String? = "", objectId: NSManagedObjectID? = nil)
    
    var infos: (title:String, slogan:String, icon: UIImage?, entity: NSManagedObject.Type, objectId: NSManagedObjectID? ) {
        switch self {
        case .accomplishments:
            return (title: "Accomplishments", slogan: "List of achievements that are both measurable and unique to a job seeker’s experience.", icon: UIImage(named: "accomplishments"), entity: Accomplishments.self, objectId: nil )
        case .additionalInformation:
            return (title: "Additional Informations", slogan: "Information about yourself that comes from outside of education and work history.", icon: UIImage(named: "information"), entity: AdditionalInformation.self, objectId: nil )
        case .certifications:
            return (title: "Certifications", slogan: "Certificates proves that you possess a certain level of professional experience.", icon: UIImage(named: "certifications"), entity: Certifications.self, objectId: nil )
        case .contactInformations:
            return (title: "Contact Informations", slogan: "Employer use this informations to reach you easily and efficiently.", icon: UIImage(named: "contactinformations"), entity: ContactInformations.self, objectId: nil )
        case .customSection:
            return (title: "Custom Section", slogan: "Custom accomplishments which wouldn’t fit to any of the conventional sections.", icon: UIImage(named: "customsection"), entity: CustomSection.self, objectId: nil )
        case .education:
            return (title: "Education", slogan: "Highlight your academic qualifications and achievements.", icon: UIImage(named: "education"), entity: Accomplishments.self, objectId: nil )
        case .interests:
            return (title: "Interests", slogan: "Subjects that fascinate you and want to learn more about.", icon: UIImage(named: "interest"), entity: Accomplishments.self, objectId: nil )
        case .languages:
            return (title: "Languages", slogan: "Languages you are proficient in besides the language your resume is written in.", icon: UIImage(named: "language"), entity: Accomplishments.self, objectId: nil )
        case .skills:
            return (title: "Skills", slogan: "Your natural talents and the expertise you develop. Skills are valuable for job seekers.", icon: UIImage(named: "skills"), entity: Accomplishments.self, objectId: nil )
        case .softwares:
            return (title: "Softwares", slogan: "List of specific subset of computer skills.", icon: UIImage(named: "software"), entity: Accomplishments.self, objectId: nil )
        case .summary:
            return (title: "Summary", slogan: "Your professional statement at the top of a resume.", icon: UIImage(named: "summary"), entity: Accomplishments.self, objectId: nil )
        case .workExperiences:
            return (title: "Work Experiences", slogan: "Describe your past jobs and professional.", icon: UIImage(named: "workExperience"), entity: Accomplishments.self, objectId: nil )
        case .custom(title: let title, slogan: let slogan, objectId: let objectId):
            return (title: title ?? "", slogan: slogan ?? "", icon: UIImage(named: "customsection"), entity: CustomSection.self, objectId: objectId )
        }
    }
    
    var description: String {
        switch self {
        case .accomplishments:
            return "Accomplishments"
        case .additionalInformation:
            return "Additional Information"
        case .certifications:
            return "Certifications"
        case .contactInformations:
            return "Contact Informations"
        case .customSection:
            return "Custom Section"
        case .education:
            return "Education"
        case .interests:
            return "Interests"
        case .languages:
            return "Languages"
        case .skills:
            return "Skills"
        case .softwares:
            return "Softwares"
        case .summary:
            return "Summary"
        case .workExperiences:
            return "Work Experiences"
        case .custom(title: let title, slogan: _, objectId: _):
            return title ?? ""
        }
    }
    
}
