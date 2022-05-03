//
//  SoftwarePresenter.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 4/2/2022.
//

import Foundation


protocol SoftwarePresenterDelegate: AnyObject {
    func presentSoftwares(list: [Softwares])
}

class SoftwarePresenter {
    
    weak var delegate: SoftwarePresenterDelegate?
    
    func fetchSoftwaresList(initialObject: Initial? = nil) -> Void{
        
        guard let softwares = initialObject?.softwares?.allObjects as? [Softwares] else { return }
        let softwaresList = softwares.sorted(by: { $0.orderIndex < $1.orderIndex })
        
        delegate?.presentSoftwares(list: softwaresList)
        
    }
    
}


