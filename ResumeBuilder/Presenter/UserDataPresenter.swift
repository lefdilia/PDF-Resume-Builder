//
//  UserDataPresenter.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 7/11/2021.
//

import Foundation
import CoreData
import UIKit

enum CreatedType: Int {
    case resume
    case coverLetter
}

struct SocialLinks {
    var link: String
    var title: String
}

struct InitialSetup {
    var color: UIColor?
}

struct UserData {
    
    var objectID: NSManagedObjectID
    var type: CreatedType
    var initialSetup: InitialSetup

    var picture: Data?
    var firstName: String
    var lastName: String
        
    var profession: String
    
    var created: Date?
    var modified: Date?
}
    
protocol UserDataPresenterDelegate: AnyObject {
    func presentUserData(userData: [UserData])
}

class UserDataPresenter {
    
    weak var delegate: UserDataPresenterDelegate?
    
    func getInitList() {
        
        var _resumeList: [UserData]? = []

        CoreDataManager.shared.fetchResume { [weak self] (error, resumeList) in
            
            for (_, resume) in resumeList.enumerated() {
                
                if let contactInformations = resume.contactInformations?.allObjects.first as? ContactInformations {
                    
                    //MARK: - Initial Setup
                    let _color = Int(resume.color)
                    let templateColor = TemplateColors.colors[_color]
                    let _intialSetup = InitialSetup(color: templateColor)
                    
                    let _objectID = resume.objectID
                    let _type = CreatedType.init(rawValue: Int(resume.initialType)) ?? .coverLetter
                    let _picture = contactInformations.photo
                    let _firstName = contactInformations.firstName ?? ""
                    let _lastName = contactInformations.lastName ?? ""
                    let _profession = contactInformations.profession ?? ""
                    let _created = resume.createdAt
                    let _modified = resume.updatedAt
                    
                    let tempResume = UserData(objectID: _objectID,
                                              type: _type,
                                              initialSetup: _intialSetup,
                                              picture: _picture,
                                              firstName: _firstName,
                                              lastName: _lastName,
                                              profession: _profession,
                                              created: _created,
                                              modified: _modified)
                    
                    _resumeList?.append(tempResume)
                }
                
                if let _resumeList = _resumeList {
                    self?.delegate?.presentUserData(userData: _resumeList)
                }
            }
        }
    }
}

