//
//  InterestsPresenter.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 2/2/2022.
//

import Foundation


protocol InterestsPresenterDelegate: AnyObject {
    func presentInterests(list: [Interests])
}


class InterestsPresenter {
    
    weak var delegate: InterestsPresenterDelegate?
    
    func fetchInterestList(initialObject: Initial? = nil) -> Void {
        
        guard let interests = initialObject?.interests?.allObjects as? [Interests] else { return }
        let interestsList = interests.sorted(by: { $0.orderIndex < $1.orderIndex })
        
        delegate?.presentInterests(list: interestsList)
        
    }
    
}
