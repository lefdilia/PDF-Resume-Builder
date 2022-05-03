//
//  EducationPresenter.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 20/1/2022.
//

import Foundation


protocol EducationPresenterDelegate: AnyObject {
    func presentEducation(list: [Education])
}


class EducationPresenter {
    
    weak var delegate: EducationPresenterDelegate?

    func fetchEducationList(initialObject: Initial? = nil) -> Void {
        
        guard let education = initialObject?.education?.allObjects as? [Education] else { return }
        let educationList = education.sorted(by: { $0.orderIndex < $1.orderIndex })
        
        delegate?.presentEducation(list: educationList)
        
    }
    
}
