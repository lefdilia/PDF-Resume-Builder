//
//  CoreDataInsertModel.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 11/1/2022.
//

import Foundation
import CoreData


protocol initialObjectDataSource {
    var initialObject: Initial? { get set }
}

struct PersonalInformationsModel: initialObjectDataSource {
    var initialObject: Initial?
    
    var firstName: String
    var lastName: String
    var profession: String?
    var address: String?
    var country: String?
    var state: String?
    var city: String?
    var zipCode: String?
    var phone: String?
    var email: String?
    var socialLinks: [String:String]
    var photo: Data?
    
    var status: Bool = true
}

struct WorkExperienceModel: initialObjectDataSource {
    var initialObject: Initial?
    
    var jobTitle: String
    var company: String
    var country: String?
    var city: String?
    var startDate:Date // 2006-12
    var endDate:Date?   // 2019-12 || Present
    var responsibilities: [String]
    
    var status: Bool = true
}

struct EducationModel: initialObjectDataSource {
    var initialObject: Initial?
    
    var schoolName: String
    var degree: String
    var field: String
    var country: String?
    var city: String?
    var startDate:Date // 2006-12
    var endDate:Date?   // 2019-12 || Present
    
    var status: Bool = true
}

struct SummaryModel: initialObjectDataSource {
    var initialObject: Initial?
    
    var objectId: NSManagedObjectID?
    var status: Bool = true
    var text: String
}

struct AdditionalInformationModel: initialObjectDataSource {
    var initialObject: Initial?
    
    var objectId: NSManagedObjectID?
    var status: Bool = false
    var text: String
}

struct AccomplishmentsModel: initialObjectDataSource {
    var initialObject: Initial?
    
    var objectId: NSManagedObjectID?
    var status: Bool = false
    var text: [String]
}

struct CustomSectionModel: initialObjectDataSource {
    var initialObject: Initial?
    
    var objectId: NSManagedObjectID?
    var status: Bool = false
    var title: String
    var text: String?
}


