//
//  SummaryPresenter.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 26/1/2022.
//

import Foundation

protocol SummariesPresenterProtocol: AnyObject {
    func presentSummary(summaries: [String], keyword: String?)
    func presentWaitStatus()
}

class SummariesPresenter {
    
    weak var delegate: SummariesPresenterProtocol?

    func fetchSummaries(keyword: String? = nil) {

        self.delegate?.presentWaitStatus()
        
        APIManager.shared.fetchSummary(keyword: keyword) { result in
            switch result {
            case .success(let summaries):
                self.delegate?.presentSummary(summaries: summaries, keyword: keyword)
            case .failure(_):
                break
            }
        }

    }
}
