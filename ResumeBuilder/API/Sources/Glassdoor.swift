//
//  Glassdoor.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 8/11/2021.
//

import Foundation



struct GlassdoorJobs: Codable {
    var employerName: String
    var jobTitle: String
    var jobLocation: String // Remote || XXX, CA
    
}

struct GlassdoorCompany: Codable {
    var logo: String
    var name: String
    var infos: [String: String?]
    var pictures: [String]?
}

class Glassdoor {
    
    public func fetchJobs(completion: @escaping (Result<[GlassdoorJobs], NetworkError>) -> Void) {
        
        guard let url = URL(string: "https://localhost:4000/glassdoor") else {
            return completion(.failure(.badUrl))
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
                let jobs = try decoder.decode([GlassdoorJobs].self, from: data)
                
                return completion(.success(jobs))
                
            }catch {
                return completion(.failure(.invalidDecode))
            }
        }
        
        task.resume()
    }
}


