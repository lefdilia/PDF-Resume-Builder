//
//  LanguagesPresenter.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 26/1/2022.
//

import Foundation


protocol LanguagesPresenterDelegate: AnyObject {
    func presentLanguages(list: [Languages])
}


class LanguagesPresenter {
    
    weak var delegate: LanguagesPresenterDelegate?
    
    func fetchLanguagesList(initialObject: Initial? = nil) -> Void{
        
        guard let languages = initialObject?.languages?.allObjects as? [Languages] else { return }
        let languagesList = languages.sorted(by: { $0.orderIndex < $1.orderIndex })
        
        delegate?.presentLanguages(list: languagesList)
        
    }
    
}
