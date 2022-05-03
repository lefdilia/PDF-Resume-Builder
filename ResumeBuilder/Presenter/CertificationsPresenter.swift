//
//  CertificationsPresenter.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 3/2/2022.
//

import Foundation


protocol CertificationsPresenterDelegate: AnyObject {
    func presentCertifications(list: [Certifications])
}

class CertificationsPresenter {
    
    weak var delegate: CertificationsPresenterDelegate?
    
    func fetchCertificationsList(initialObject: Initial? = nil) -> Void{
        
        guard let certifications = initialObject?.certifications?.allObjects as? [Certifications] else { return }
        let certificationsList = certifications.sorted(by: { $0.orderIndex < $1.orderIndex })
        
        delegate?.presentCertifications(list: certificationsList)
        
    }
    
}
