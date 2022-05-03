//
//  Initial+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 19/3/2022.
//

import UIKit



extension Initial {
    
    func buildResume() -> ResumeData? {
        
        var resumeData = ResumeData(sections: [], stacks: [])
        
        if let summary = self.summary?.allObjects.first as? Summary {
            resumeData.summary = summary.text
        }
        
        var sections = [SectionBlock]()
        var stacks = [StackBlock]()
        
        if let contactInformations = self.contactInformations?.allObjects.first as? ContactInformations {
            
            if let data = contactInformations.photo {
                resumeData.image = UIImage(data: data)?.withRenderingMode(.alwaysOriginal)
            }
            
            resumeData.firstName = contactInformations.firstName
            resumeData.lastName = contactInformations.lastName
            resumeData.profession = contactInformations.profession
            
            let socialLinks = contactInformations.socialLinks ?? [:]
            
            let _phone = contactInformations.phone ?? ""
            let _address = contactInformations.address ?? ""
            let _email = contactInformations.email ?? ""
            
            let personalInfoBlock = SectionBlock(index: 0, section: .personalInfo, infos: [
                "address".localized(): !_address.isEmpty ? _address : nil,
                "phone".localized(): !_phone.isEmpty ? _phone : nil,
                "email".localized(): !_email.isEmpty ? _email : nil,
                "Website".localized(): socialLinks["Website"],
                "Patreon": socialLinks["Patreon"],
                "Github": socialLinks["Github"],
                "Twitter": socialLinks["Twitter"],
                "Linkedin": socialLinks["Linkedin"],
                "Medium": socialLinks["Medium"],
                "Portfolio": socialLinks["Portfolio"],
            ])
            
            sections.append(personalInfoBlock)
        }
        
        //MARK: - Skills
        if let skills = self.skills?.allObjects as? [Skills] {
            
            var infos: [String:Int] = [:]
            
            for skill in skills {
                if let title = skill.title, !title.isEmpty {
                    let level = Int(skill.level)
                    infos[title] = level
                }
            }
            
            let skillsBlock = SectionBlock(index: 1, section: .skills, infos: infos)
            
            if infos.count > 0 {
                sections.append(skillsBlock)
            }
        }
        
        //MARK: - Languages
        if let languages = self.languages?.allObjects as? [Languages] {
            
            var infos: [String: Any] = [:]
            
            for language in languages {
                if let title = language.title, !title.isEmpty {
                    let level = Int(language.level)
                    infos[title] = level
                }
            }
            
            let languagesBlock = SectionBlock(index: 2, section: .languages, infos: infos)
            
            if infos.count > 0 {
                sections.append(languagesBlock)
            }
        }
        //MARK: - Software
        if let softwares = self.softwares?.allObjects as? [Softwares] {
            
            var infos: [String:Int] = [:]
            
            for software in softwares {
                if let title = software.title, !title.isEmpty {
                    let level = Int(software.level)
                    infos[title] = level
                }
            }
            
            let softwaresBlock = SectionBlock(index: 2, section: .softwares, infos: infos)
            
            if infos.count > 0 {
                sections.append(softwaresBlock)
            }
        }
        //MARK: - workHistory
        /*
         (title: "Senior Project Manager", location: "Seton Hospital, ME", rangeDate: (start: "2006-12", finish: "Present"), roles: ["Lorem ipsum dolor sit amet.","Consec tetur adipiscing elit."]),
         */
        if let workExperiences = self.workExperiences?.allObjects as? [WorkExperiences] {
            
            let dateFormat = "MM-yyyy"
            
            var infos = [builtBlock]()
            for workExperience in workExperiences {
                
                let _title = workExperience.jobTitle ?? ""
                let _city = workExperience.city ?? "", _country = workExperience.country ?? ""
                let _company = workExperience.company ?? ""
                var _location = "\(!_company.isEmpty ? "\(_company) - " : "")\(_city.capitalized)\(!_country.isEmpty ? ", \(_country.capitalized)" : "")"
                
                _location = _location.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "-$", with: "", options: .regularExpression, range: nil)
                
                let _startDate = formatRSDate(date: workExperience.startDate, format: dateFormat)
                
                var _endDate: String? = "Present"
                if let endDate = workExperience.endDate {
                    let formatter = DateFormatter()
                    formatter.dateFormat = dateFormat
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    let dateString = formatter.string(from: endDate)
                    _endDate = dateString.capitalized
                }
                
                let roles = workExperience.responsibilities ?? []
                let work: builtBlock = (title: _title,
                                        location: Optional(_location),
                                        rangeDate: (start: _startDate, finish: _endDate),
                                        roles: roles)
                
                infos.append(work)
            }
            
            let workExperiencesBlock = StackBlock(index: 0, section: .workExperiences, infos: infos)
            
            if workExperiences.count > 0 {
                stacks.append(workExperiencesBlock)
            }
        }
        //MARK: - Education
        /*
         (title: "Harvard CS250", location: "Seton Hospital, ME", rangeDate: (start: "1996-09", finish: nil), roles: ["Lorem ipsum dolor sit amet.","Consec tetur adipiscing elit."] ),
         */
        if let education = self.education?.allObjects as? [Education] {
            
            let dateFormat = "MM-yyyy"
            
            var infos = [builtBlock]()
            for education in education { //Field of stydy && Program /!\
                
                let _title = education.degree ?? ""
                let _city = education.city ?? "", _country = education.country ?? ""
                let _schoolName = education.schoolName ?? ""
                var _location = "\(!_schoolName.isEmpty ? "\(_schoolName) - " : "")\(_city.capitalized)\(!_country.isEmpty ? ", \(_country.capitalized)" : "")"
                
                _location = _location.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "-$", with: "", options: .regularExpression, range: nil)
                
                
                let _startDate = formatRSDate(date: education.startDate, format: dateFormat)
                
                var _endDate: String? = "Present"
                if let endDate = education.endDate {
                    let formatter = DateFormatter()
                    formatter.dateFormat = dateFormat
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    let dateString = formatter.string(from: endDate)
                    _endDate = dateString.capitalized
                }
                
                let roles = [String]()
                let educationBuiltBlock: builtBlock = (title: _title,
                                                       location: Optional(_location),
                                                       rangeDate: (start: _startDate, finish: _endDate),
                                                       roles: roles)
                
                infos.append(educationBuiltBlock)
                
            }
            
            let educationBlock = StackBlock(index: 1, section: .education, infos: infos)
            
            if education.count > 0 {
                stacks.append(educationBlock)
            }
        }
        //MARK: - Certifications
        /*
         (title: "Apple Certification", location: nil, rangeDate: (start: "1996-09", finish: nil), roles: [] ),
         */
        if let certifications = self.certifications?.allObjects as? [Certifications] {
            
            let dateFormat = "MM-yyyy"
            var infos = [builtBlock]()
            
            for certification in certifications {
                
                guard let _title = certification.title else {
                    continue
                }
                
                let _date = formatRSDate(date: certification.date, format: dateFormat)
                let roles = [String]()
                
                let certificationBuiltBlock: builtBlock = (title: _title,
                                                           location: nil,
                                                           rangeDate: (start: _date, finish: nil),
                                                           roles: roles)
                
                infos.append(certificationBuiltBlock)
            }
            
            let certificationBlock = StackBlock(index: 2, section: .certifications, infos: infos)
            
            if certifications.filter({ $0.title != nil }).count > 0 {
                stacks.append(certificationBlock)
            }
            
        }
        
        //MARK: - Accomplishments
        if let accomplishments = self.accomplishments?.allObjects.first as? Accomplishments {
            
            let roles = accomplishments.text ?? []
            let accomplishmentBuiltBlock: builtBlock = (title: "",
                                                        location: nil,
                                                        rangeDate: (start: "", finish: nil),
                                                        roles: roles)
            
            let infos: [builtBlock] = [accomplishmentBuiltBlock]
            let accomplishmentBlock = StackBlock(index: 3, section: .accomplishments, infos: infos)
            
            if roles.count > 0 {
                stacks.append(accomplishmentBlock)
            }
        }
        
        //MARK: - AdditionalInformation
        if let additionalInformation = self.additionalInformation?.allObjects.first as? AdditionalInformation {
            
            let _title = additionalInformation.text ?? ""
            
            let additionalInformationBuiltBlock: builtBlock = (title: _title,
                                                               location: nil,
                                                               rangeDate: (start: "", finish: nil),
                                                               roles: [])
            
            let infos: [builtBlock] = [additionalInformationBuiltBlock]
            
            let additionalInformationBlock = StackBlock(index: 4, section: .additionalInformation, infos: infos)
            
            if !_title.isEmpty {
                stacks.append(additionalInformationBlock)
            }
        }
        
        //MARK: - Interests
        /*(title: "", location: ["Lorem ipsum","Lorem ipsum","Lorem ipsum"].joined(separator: " - "), rangeDate: (start: "", finish: nil), roles: [])*/
        if let interests = self.interests?.allObjects as? [Interests] {
            
            var _interestList = [String]()
            
            for interest in interests {
                if let _title = interest.title {
                    _interestList.append(_title)
                }
            }
            
            let interestBuiltBlock: builtBlock = (title: "",
                                                  location: _interestList.joined(separator: " - "),
                                                  rangeDate: (start: "", finish: nil),
                                                  roles: [])
            
            let infos: [builtBlock] = [interestBuiltBlock]
            let interestsBlock = StackBlock(index: 5, section: .interests, infos: infos)
            
            if _interestList.count > 0 {
                stacks.append(interestsBlock)
            }
            
        }
        
        //MARK: - Custom Sections
        
        //1. Get last index in stacks
        /*
         StackBlock(index: 7, section: .default(title: "Custom Lorem Vlad"), infos:[ (title: "Lorem ipsum dolor sit amet, consec tetur adipiscing elit.Lorem ipsum dolor sit amet, consec tetur adipiscing elit.", location: nil, rangeDate: (start: "", finish: nil), roles: [] ) ]),
         */
        if let customSections = self.customSection?.allObjects as? [CustomSection] {
            
            let lastIndexInStack = stacks.count
            
            for (index, customSection) in customSections.enumerated() {
                
                let _index = lastIndexInStack+index+1
                
                guard let _title = customSection.title else {
                    continue
                }
                
                let _section: BuiltInSection = .customSection(title: _title)
                
                guard let _text = customSection.text else {
                    continue
                }
                
                let customSectionBuiltBlock: builtBlock = (title: _text,
                                                           location: nil,
                                                           rangeDate: (start: "", finish: nil),
                                                           roles: [])
                
                let infos: [builtBlock] = [customSectionBuiltBlock]
                let customSectionBlock = StackBlock(index: _index, section: _section, infos: infos)
                
                stacks.append(customSectionBlock)
            }
        }
        
        
        //MARK: - Final Sections & Stacks
        resumeData.sections = sections
        resumeData.stacks = stacks
        
        return resumeData
    }
}
