//
//  SkillPresenter.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 21/1/2022.
//

import Foundation



protocol SkillPresenterDelegate: AnyObject {
    func presentSkills(list: [Skills])
}


class SkillsPresenter {
    
    weak var delegate: SkillPresenterDelegate?
    
    func fetchSkillsList(initialObject: Initial? = nil) -> Void{
        
        guard let skills = initialObject?.skills?.allObjects as? [Skills] else { return }
        let skillList = skills.sorted(by: { $0.orderIndex < $1.orderIndex })
        
        delegate?.presentSkills(list: skillList)
        
    }
    
}
