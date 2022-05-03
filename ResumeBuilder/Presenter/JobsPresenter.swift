//
//  JobsPresenter.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 8/11/2021.
//

import Foundation

protocol JobsPresenterProtocol: AnyObject {
    func presentJobs(jobs: [Job], location: String?)
    func presentWaitStatus()
}

/*
 1. From user Settings -> List all Sources  (Depend on what User choose before)
 2. Loop through all API/Sources
 3. Grab `Job Type` we already build
 4. Present the Job via Delegate
 */

class JobsPresenter {
    
    weak var delegate: JobsPresenterProtocol?

    func fetchJobs(filters: JobSearchFilters? = nil) {
        
        self.delegate?.presentWaitStatus()
        
        APIManager.shared.fetchJobs(filters: filters) { result in
            switch result {
            case .success(let jobs):
                self.delegate?.presentJobs(jobs: jobs, location: filters?.location)
            case .failure(_):
                break
            }
        }
        
    }
}
