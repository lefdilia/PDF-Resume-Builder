//
//  CoreDataManager.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 1/12/2021.
//

import Foundation
import CoreData


struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "ResumeBuilderModel")
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                fatalError("Loading of store failed : \(error)")
            }
        }
        return persistentContainer
    }()
    
    //MARK: - Setup Initial Detail
    //["fontType": 3, "format": 1, "imageType": 1, "template": 0, "color": 0]
    
    func setupInitialDetail(options: [String: Int], completion: @escaping (Initial?, Error?)->()){
        
        // Create a new background managed object context
        let managedObjectContext = persistentContainer.newBackgroundContext()
        managedObjectContext.automaticallyMergesChangesFromParent = true
        
        managedObjectContext.perform {
            
            guard let initialEntity = NSEntityDescription.entity(forEntityName: "Initial", in: managedObjectContext) else {
                completion(nil, "Initial entity error" as? Error)
                return
            }
            
            let initialDetail = NSManagedObject(entity: initialEntity, insertInto: managedObjectContext)
            
            initialDetail.setValue(Int16(options["template"] ?? 0), forKey: "template")
            initialDetail.setValue(Int16(options["imageType"] ?? 0), forKey: "imageType")
            initialDetail.setValue(Int16(options["format"] ?? 0), forKey: "format")
            initialDetail.setValue(Int16(options["fontType"] ?? 3), forKey: "font")
            initialDetail.setValue(Int16(options["color"] ?? 0), forKey: "color")
            
            initialDetail.setValue(UUID(), forKey: "identifier")
            initialDetail.setValue(Date(), forKey: "createdAt")
            
            do {
                try managedObjectContext.save()
                let _initialDetail = self.persistentContainer.viewContext.object(with: initialDetail.objectID) as? Initial
                completion(_initialDetail, nil)
            }catch {
                completion(nil, error)
            }
            
        }
    }
    
    func updateInitial(options: [String:Int]?, initialObject: Initial?, completion: ((Error?)->())?) {
        
        guard let initialContext = initialObject?.managedObjectContext else { return }
        
        guard let options = options else {
            completion?(nil)
            return
        }
        
        if let color = options["color"] {
            initialObject?.color = Int16(color)
        }
        
        if let imageType = options["imageType"] {
            initialObject?.imageType = Int16(imageType)
        }
        
        if let fontType = options["fontType"] {
            initialObject?.font = Int16(fontType)
        }
        
        if let format = options["format"] {
            initialObject?.format = Int16(format)
        }
        
        if let template = options["template"] {
            initialObject?.template = Int16(template)
        }
        
        if initialContext.hasChanges {
            initialObject?.updatedAt = Date()
            do {
                try initialContext.save()
                completion?(nil)
            }catch {
                completion?(error)
            }
        }
    }
    
    //MARK: - Finalize
    func finalizeResume(initialObject: Initial?, completion: ((Error?)->())?) {
        guard let initialContext = initialObject?.managedObjectContext else {
            completion?(nil)
            return
        }
        
        guard let personalInfo = initialObject?.contactInformations?.allObjects as? [ContactInformations],
        personalInfo.count > 0 else {
            completion?(nil)
            return
        }
        
        initialObject?.status = true
        
        if initialContext.hasChanges {
            initialObject?.updatedAt = Date()
            do {
                try initialContext.save()
                completion?(nil)
            }catch {
                completion?(error)
            }
        }
    }
    
    //MARK: - Fetch Resume (CollectionView)
    func fetchResume(completion: ((Error?, [Initial])->())? )  {
        
        let managedObjectContext = self.persistentContainer.viewContext
        let request = NSFetchRequest<Initial>(entityName: "Initial")
        
        let predicate: NSPredicate = NSPredicate(format: "status == true")
        request.predicate = predicate
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "updatedAt", ascending: false)
        ]
        
        do {
            let resumeList = try managedObjectContext.fetch(request)
            completion?(nil, resumeList)
        }catch {
            completion?(error, [])
        }
    }
    
    func findResumeById(objectID: NSManagedObjectID?, completion: @escaping (Initial?)->()) {
        
        let context = self.persistentContainer.viewContext
        
        guard let objectID = objectID else {
            return completion(nil)
        }
        
        let resumeObject = context.object(with: objectID) as? Initial
        
        completion(resumeObject)
    }
    
    //MARK: - Delete Resume
    func deleteResume(objectId: NSManagedObjectID? , completion: (Error?)->() ){
        
        guard let objectId = objectId else {
            completion(nil)
            return
        }
        
        let context = self.persistentContainer.viewContext
        
        let object = context.object(with: objectId)
        context.delete(object)
        
        do {
            try context.save()
            completion(nil)
        }catch {
            completion(error)
        }
    }
    
    //MARK: - Update Order WorkExperience
    func updateDisplayOrder<T: NSManagedObject>(list: [T], completion: ((Error?)->())? ) {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = self.persistentContainer.viewContext
        for (index, work) in list.enumerated() {
            let orderIndex = Int16(index)
            work.setValue(orderIndex, forKey: "orderIndex")
            do {
                try privateContext.save()
                try privateContext.parent?.save()
            }catch {
                completion?(error)
            }
        }
        completion?(nil)
    }
    
    //MARK: - Setup ContactInformations
    func setupContactInformations(options: PersonalInformationsModel, objectId: NSManagedObjectID? = nil, completion: ((Error?)->())? ){
        
        let privateContext = self.persistentContainer.viewContext
        
        var contactInformations: ContactInformations!
        
        if let objectId = objectId {
            contactInformations = privateContext.object(with: objectId) as? ContactInformations
        }else{
            contactInformations = ContactInformations(context: privateContext)
        }
        
        contactInformations.firstName = options.firstName
        contactInformations.lastName = options.lastName
        contactInformations.profession = options.profession
        contactInformations.address = options.address
        contactInformations.country = options.country
        contactInformations.state = options.state
        contactInformations.city = options.city
        contactInformations.zipCode = options.zipCode
        contactInformations.phone = options.phone
        contactInformations.email = options.email
        contactInformations.socialLinks = options.socialLinks
        contactInformations.photo = options.photo
        
        contactInformations.status = options.status
        
        if let initialObject = options.initialObject {
            contactInformations.initialObject = initialObject
            contactInformations.initialObject?.updatedAt = Date()
        }
        
        do {
            try privateContext.save()
            completion?(nil)
        }catch {
            completion?(error)
        }
    }
    
    //MARK: - Work Experiences
    func setupWorkExperiences(options: WorkExperienceModel, objectId: NSManagedObjectID? = nil, completion: (Error?)->()){
        
        let privateContext = self.persistentContainer.viewContext
        var workExperiences: WorkExperiences!
        
        if let objectId = objectId {
            workExperiences = privateContext.object(with: objectId) as? WorkExperiences
        }else{
            workExperiences = WorkExperiences(context: privateContext)
        }
        
        workExperiences.jobTitle = options.jobTitle
        workExperiences.company = options.company
        workExperiences.country = options.country
        workExperiences.city = options.city
        workExperiences.startDate = options.startDate
        workExperiences.endDate = options.endDate
        workExperiences.responsibilities = options.responsibilities
        
        if let initialObject = options.initialObject {
            workExperiences.initialObject = initialObject
            workExperiences.initialObject?.updatedAt = Date()
        }
        
        do {
            try privateContext.save()
            completion(nil)
        }catch {
            completion(error)
        }
    }
    
    
    func fetchWorkExperiences() throws -> [WorkExperiences]  {
        
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<WorkExperiences>(entityName: "WorkExperiences")
        request.sortDescriptors = [
            NSSortDescriptor(key: "orderIndex", ascending: true),
            NSSortDescriptor(key: "startDate", ascending: false),
        ]
        
        let experiences: [WorkExperiences] = try context.fetch(request)
        return experiences
    }
    
    func deleteWorkExperience(work: WorkExperiences, completion: (Error?)->()) {
        guard let context = work.managedObjectContext else { return completion(nil) }
        if context == self.persistentContainer.viewContext {
            context.delete(work)
            do {
                try context.save()
                completion(nil)
            }catch {
                completion(error)
            }
        }else{
            completion("No context available" as? Error)
        }
    }
    
    
    //MARK: - Education
    
    func setupEducation(options: EducationModel, objectId: NSManagedObjectID? = nil, completion: (Error?)->()){
        let privateContext = self.persistentContainer.viewContext
        
        var education: Education!
        
        if let objectId = objectId {
            education = privateContext.object(with: objectId) as? Education
        }else{
            education = Education(context: privateContext)
        }
        
        education.schoolName = options.schoolName
        education.degree = options.degree
        education.field = options.field
        education.country = options.country
        education.city = options.city
        education.startDate = options.startDate
        education.endDate = options.endDate
        
        if let initialObject = options.initialObject {
            education.initialObject = initialObject
            education.initialObject?.updatedAt = Date()
        }
        
        do {
            try privateContext.save()
            
            completion(nil)
        }catch {
            completion(error)
        }
    }
    
    func fetchEducation() throws -> [Education]  {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<Education>(entityName: "Education")
        request.sortDescriptors = [
            NSSortDescriptor(key: "orderIndex", ascending: true),
            NSSortDescriptor(key: "startDate", ascending: false),
        ]
        let educationList: [Education] = try context.fetch(request)
        return educationList
    }
    
    func deleteEducation(item: Education, completion: (Error?)->()) {
        guard let context = item.managedObjectContext else { return completion(nil) }
        if context == self.persistentContainer.viewContext {
            context.delete(item)
            do {
                try context.save()
                completion(nil)
            }catch {
                completion(error)
            }
        }else{
            completion("No context available" as? Error)
        }
    }
    
    
    //MARK: - Skills
    
    func setupSkills(completion: ((Error?)->())? = nil ) -> Void {
        let privateContext = self.persistentContainer.viewContext
        do {
            try privateContext.save()
            completion?(nil)
        }catch {
            completion?(error)
        }
    }
    
    func fetchSkills() throws -> [Skills]  {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<Skills>(entityName: "Skills")
        request.sortDescriptors = [
            NSSortDescriptor(key: "orderIndex", ascending: true),
        ]
        let skillsList: [Skills] = try context.fetch(request)
        return skillsList
    }
    
    func deleteSkill(item: Skills, completion: (Error?)->()) {
        guard let context = item.managedObjectContext else { return completion(nil) }
        if context == self.persistentContainer.viewContext {
            context.delete(item)
            do {
                try context.save()
                completion(nil)
            }catch {
                completion(error)
            }
        }else{
            completion("No context available" as? Error)
        }
    }
    
    
    //MARK: - Languages
    
    func setupLanguages(completion: ((Error?)->())? = nil ) -> Void {
        let privateContext = self.persistentContainer.viewContext
        do {
            try privateContext.save()
            completion?(nil)
        }catch {
            completion?(error)
        }
    }
    
    func fetchLanguages() throws -> [Languages]  {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<Languages>(entityName: "Languages")
        request.sortDescriptors = [
            NSSortDescriptor(key: "orderIndex", ascending: true),
        ]
        let languagesList: [Languages] = try context.fetch(request)
        return languagesList
    }
    
    func deleteLanguage(item: Languages, completion: (Error?)->()) {
        guard let context = item.managedObjectContext else { return completion(nil) }
        if context == self.persistentContainer.viewContext {
            context.delete(item)
            do {
                try context.save()
                completion(nil)
            }catch {
                completion(error)
            }
        }else{
            completion("No context available" as? Error)
        }
    }
    
    //MARK: - Summary
    
    func setupSummary(options: SummaryModel, completion: ((Error?)->())? ){
        
        let privateContext = self.persistentContainer.viewContext
        
        var summary: Summary!
        
        if let objectId = options.objectId {
            summary = privateContext.object(with: objectId) as? Summary
        }else{
            summary = Summary(context: privateContext)
        }
        
        summary.text = options.text
        
        if let initialObject = options.initialObject {
            summary.initialObject = initialObject
            summary.initialObject?.updatedAt = Date()
        }
        
        do {
            try privateContext.save()            
            completion?(nil)
        }catch {
            completion?(error)
        }
    }
    
    //MARK: - Interests
    func setupInterests(completion: ((Error?)->())? = nil ) -> Void {
        let privateContext = self.persistentContainer.viewContext
        do {
            try privateContext.save()
            completion?(nil)
        }catch {
            completion?(error)
        }
    }
    
    //MARK: - Additional Information
    
    func setupAdditionalInformations(options: AdditionalInformationModel, completion: ((Error?)->())? ){
        
        let privateContext = self.persistentContainer.viewContext
        
        var additionalInformation: AdditionalInformation!
        
        if let objectId = options.objectId {
            additionalInformation = privateContext.object(with: objectId) as? AdditionalInformation
        }else{
            additionalInformation = AdditionalInformation(context: privateContext)
        }
        
        additionalInformation.text = options.text
        additionalInformation.status = options.status
        
        if let initialObject = options.initialObject {
            additionalInformation.initialObject = initialObject
            additionalInformation.initialObject?.updatedAt = Date()
        }
        
        do {
            try privateContext.save()
            completion?(nil)
        }catch {
            completion?(error)
        }
    }
    
    
    //MARK: - Skills
    
    func setupCertifications(completion: ((Error?)->())? = nil ) -> Void {
        let privateContext = self.persistentContainer.viewContext
        do {
            try privateContext.save()
            completion?(nil)
        }catch {
            completion?(error)
        }
    }
    
    //MARK: - Accomplishments
    
    func setupAccomplishments(options: AccomplishmentsModel, completion: ((Error?)->())? ){
        
        let privateContext = self.persistentContainer.viewContext
        
        var accomplishments: Accomplishments!
        
        if let objectId = options.objectId {
            accomplishments = privateContext.object(with: objectId) as? Accomplishments
        }else{
            accomplishments = Accomplishments(context: privateContext)
        }
        
        accomplishments.text = options.text
        accomplishments.status = options.status
        
        if let initialObject = options.initialObject {
            accomplishments.initialObject = initialObject
            accomplishments.initialObject?.updatedAt = Date()
        }
        
        do {
            try privateContext.save()
            completion?(nil)
        }catch {
            completion?(error)
        }
    }
    
    //MARK: - Softwares
    
    func setupSoftwares(completion: ((Error?)->())? = nil ) -> Void {
        let privateContext = self.persistentContainer.viewContext
        do {
            try privateContext.save()
            completion?(nil)
        }catch {
            completion?(error)
        }
    }
    
    
    //MARK: - Custom section
    
    func setupSuggestedSections(sections: [MainSections], initialObject: Initial?, completion: ((Error?)->())? ){
        
        let privateContext = self.persistentContainer.viewContext
        
        do {
            
            let _ = try sections.map { _section in
                
                if _section == .accomplishments {
                    let accomplishmentsModel = AccomplishmentsModel(initialObject: initialObject, status: true, text: [])
                    self.setupAccomplishments(options: accomplishmentsModel, completion: nil)
                }
                
                if _section == .additionalInformation {
                    let additionalInformationModel = AdditionalInformationModel(initialObject: initialObject, status: true, text: "")
                    self.setupAdditionalInformations(options: additionalInformationModel, completion: nil)
                }
                
                if _section == .certifications {
                    let nCertification = Certifications(context: privateContext)
                    nCertification.initialObject = initialObject
                    nCertification.status = true
                    try? privateContext.save()
                }
                
                if _section == .interests {
                    let nInterest = Interests(context: privateContext)
                    nInterest.initialObject = initialObject
                    nInterest.status = true
                    try privateContext.save()
                }
                
                if _section == .softwares {
                    let nSoftwares = Softwares(context: privateContext)
                    nSoftwares.initialObject = initialObject
                    nSoftwares.status = true
                    nSoftwares.title = ""
                    nSoftwares.level = Int16(3)
                    try privateContext.save()
                }
                
                if _section == .custom(title: _section.description) {
                    let sectionTitle = _section.description
                    let customSectionModel = CustomSectionModel(initialObject: initialObject, status: true, title: sectionTitle)
                    self.setupCustomSection(options: customSectionModel, completion: nil)
                }
                
            }
            
        }catch {
            completion?(error)
        }
        
        completion?(nil)
        
    }
    
    
    func setupCustomSection(options: CustomSectionModel, completion: ((Error?)->())? ){
        
        let privateContext = self.persistentContainer.viewContext
        
        var customSection: CustomSection!
        
        if let objectId = options.objectId {
            customSection = privateContext.object(with: objectId) as? CustomSection
        }else{
            customSection = CustomSection(context: privateContext)
        }
        
        customSection.title = options.title
        customSection.text = options.text
        customSection.status = options.status
        
        if let initialObject = options.initialObject {
            customSection.initialObject = initialObject
        }
        
        do {
            try privateContext.save()
            completion?(nil)
        }catch {
            completion?(error)
        }
    }
    
    
    //MARK: - Remove ObjectFromContext
    func removeObject(objectId: NSManagedObjectID?, completion: (Error?)->()) {
        
        guard let objectId = objectId else { return }
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let objectToRemove = context.object(with: objectId)
        
        context.delete(objectToRemove)
        do {
            try context.save()
            completion(nil)
        }catch {
            completion(error)
        }
        
    }
    
    //MARK: - Remove Section
    
    func removeSection(section: MainSections?, initialObject: Initial?, completion: (Error?)->()) {
        
        guard let initialContext = initialObject?.managedObjectContext else { return }
        
        do {
            
            //MARK: - Side Sections
            
            if section.self == .accomplishments {
                if let accomplishement = initialObject?.accomplishments?.allObjects as? [Accomplishments] {
                    for object in accomplishement {
                        initialContext.delete(object)
                    }
                    
                    try initialContext.save()
                }
            }
            
            if section.self == .additionalInformation {
                if let additionalInformation = initialObject?.additionalInformation?.allObjects as? [AdditionalInformation] {
                    for object in additionalInformation {
                        initialContext.delete(object)
                    }
                    try initialContext.save()
                }
            }
            
            if section.self == .certifications {
                if let certifications = initialObject?.certifications?.allObjects as? [Certifications] {
                    for object in certifications {
                        initialContext.delete(object)
                    }
                    try initialContext.save()
                }
            }
            
            if section.self == .interests {
                if let interests = initialObject?.interests?.allObjects as? [Interests] {
                    for object in interests {
                        initialContext.delete(object)
                    }
                    try initialContext.save()
                }
            }
            
            if section.self == .softwares {
                if let softwares = initialObject?.softwares?.allObjects as? [Softwares] {
                    for object in softwares {
                        initialContext.delete(object)
                    }
                    try initialContext.save()
                }
            }
            
            //MARK: - Important Sections
            
            if section.self == .contactInformations {
                if let contactInformations = initialObject?.contactInformations?.allObjects as? [ContactInformations] {
                    _ = contactInformations.map({ $0.status = false })
                    initialObject?.contactInformations = nil
                    try initialContext.save()
                }
            }
            
            if section.self == .workExperiences {
                if let workExperiences = initialObject?.workExperiences?.allObjects as? [WorkExperiences] {
                    _ = workExperiences.map({ $0.status = false })
                    initialObject?.contactInformations = nil
                    try initialContext.save()
                }
            }
            
            if section.self == .education {
                if let education = initialObject?.education?.allObjects as? [Education] {
                    _ = education.map({ $0.status = false })
                    initialObject?.contactInformations = nil
                    try initialContext.save()
                }
            }
            
            if section.self == .skills {
                if let skills = initialObject?.skills?.allObjects as? [Skills] {
                    _ = skills.map({ $0.status = false })
                    initialObject?.skills = nil
                    try initialContext.save()
                }
            }
            
            if section.self == .languages {
                if let languages = initialObject?.languages?.allObjects as? [Languages] {
                    _ = languages.map({ $0.status = false })
                    initialObject?.languages = nil
                    try initialContext.save()
                }
            }
            
            if section.self == .summary {
                if let summary = initialObject?.summary?.allObjects as? [Summary] {
                    _ = summary.map({ $0.status = false })
                    initialObject?.summary = nil
                    try initialContext.save()
                }
            }
            
            //Custom Section remove
            if section?.infos.entity is CustomSection.Type {
                
                let objectId = section?.infos.objectId
                
                if let customSections = initialObject?.customSection?.allObjects as? [CustomSection] {
                    if let _section = customSections.first(where: { $0.objectID == objectId }) {
                        initialContext.delete(_section)
                        try initialContext.save()
                    }
                }
                
            }
            
        }catch {
            completion(error)
        }
        
        completion(nil)
    }
    
}
