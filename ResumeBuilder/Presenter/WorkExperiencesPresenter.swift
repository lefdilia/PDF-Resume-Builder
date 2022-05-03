//
//  WorkExperiencesPresenter.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 11/1/2022.
//

import Foundation


protocol WorkExperiencesPresenterDelegate: AnyObject {
    func presentWorkExperiences(list: [WorkExperiences])
}


class WorkExperiencesPresenter {
    
    weak var delegate: WorkExperiencesPresenterDelegate?
 
     func fetchWorkExperiences(initialObject: Initial? = nil) -> Void{
         
         guard let experiences = initialObject?.workExperiences?.allObjects as? [WorkExperiences] else { return }
         let experiencesList = experiences.sorted(by: { $0.orderIndex < $1.orderIndex })
         
         delegate?.presentWorkExperiences(list: experiencesList)
         
     }
     
}
