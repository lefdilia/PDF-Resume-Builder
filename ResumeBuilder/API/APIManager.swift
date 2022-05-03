//
//  APIManager.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 21/11/2021.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case badResponse
    case invalidDecode
    
    var localizedDescription: String {
        switch self {
        case .badUrl:
            return "Invalid URL"
        case .badResponse:
            return "Corrupted Response"
        case .invalidDecode:
            return "JSON decode failed"
        }
    }
}

struct API {
    static var Jooble = (
        endPoint: "https://jooble.ovrg/api/",
        appKey : "01fe3881-3499-4e9f-b42c-ce8f74c2d513")
    
    static var Adzuna = (
        endPoint: "http://api.adzuna.com/v1/api/jobs",
        appId: "7b7f8e35",
        appKey: "fc3d2669a0b1de0dd5e86acd9bb9084b",
        limitPerPage: 200)
    
    static var Usajobs = (
        endPoint: "https://data.usajobs.gov/api/search?",
        agent: "lefdilia@gmail.com",
        host: "data.usajobs.gov",
        authKey: "mosYeDzUTbKVveKDv8sDmhwbDRHx0opmYg0fe8Wippg=",
        limitPerPage: 100)
    
    static var Reed = (
        endPoint: "https://www.reed.co.uk/api/1.0/search",
        authKey: "Basic YTYwMWY3ZTEtODdjMi00ZDY0LWIzYzktOGRjMmIxNDI5MjRlOg==",
        limitPerPage: 100)
    
    static var Summaries = (
        endPoint: "https://firebasestorage.googleapis.com/v0/b/resume-builder-332616.appspot.com/o/summaries.json?alt=media&token=146861d5-5ea8-40ce-8f63-0da54385fbcd",
        authKey: "",
        limitPerPage: 100
    )
}


class APIManager {
    
    init(){}
    static let shared = APIManager()
    
    struct Summaries: Codable {
        var jobspresentation: [JobPresentation]

        struct JobPresentation: Codable {
            var tags: [String]
            var summaries: [String]
        }
    }
    
    func fetchSummary(keyword: String?, completion: @escaping (Result<[String], Error>) -> Void) {
        
        guard let keyword = keyword else {
            return completion(.success([]))
        }
                
        let APILink = API.Summaries.endPoint
        
        guard let url = URL(string: APILink) else {
            return completion(.failure(NetworkError.badUrl))
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                return completion(.failure(NetworkError.badResponse))
            }
                        
            do {
                let decoder = JSONDecoder()
                let decodedSummaries = try decoder.decode(Summaries.self, from: data)
                let summaries = decodedSummaries.jobspresentation.first(where: { $0.tags.contains { $0.lowercased() == keyword.lowercased() } })?.summaries

                if let summaries = summaries {
                    return completion(.success(summaries))
                }
                
                return completion(.success([]))
                
            }catch{
                return completion(.failure(NetworkError.invalidDecode))
            }
        }
        task.resume()
        
    }
    
    
    func fetchJobs(filters: JobSearchFilters?, completion: @escaping (Result<[Job], Error>) -> Void) {
        
        guard let filters = filters else {
            return completion(.success([]))
        }
        
        var jobs = [Job]()
        
        let group = DispatchGroup()
        
        //MARK: - Adzuna
        for page in 1...3 {
            group.enter()
            Adzuna().fetch(filters: filters, page) { result in
                switch result {
                case .success(let _jobs):
                    jobs.append(contentsOf: _jobs)
                    break
                case .failure(_):
                    break
                }
                group.leave()
            }
        }

        //MARK: - Jooble Limited to Only 3 Pages
        for page in 1...3 {
            group.enter()
            Jooble().fetch(filters: filters, page) { result in
                switch result {
                case .success(let _jobs):
                    jobs.append(contentsOf: _jobs)
                    break
                case .failure(_):
                    break
                }
                group.leave()
            }
        }
        
        //MARK: - Usajobs
        group.enter()
        Usajobs().fetch(filters: filters) { result in
            switch result {
            case .success(let _jobs):
                jobs.append(contentsOf: _jobs)
                break
            case .failure(_):
                break
            }
            group.leave()
        }
        
        //MARK: - Reed.co.uk
        for _page in 1...3 {
            group.enter()
            Reed().fetch(filters: filters, _page) { result in
                switch result {
                case .success(let _jobs):
                    jobs.append(contentsOf: _jobs)
                    break
                case .failure(_):
                    break
                }
                group.leave()
            }
        }
        
        //MARK: - Im Done Here ^^
        group.notify(queue: .main) {
            jobs = jobs.sorted{ $0.source.rawValue > $1.source.rawValue}
            return completion(.success(jobs))
        }
        
    }
    
}
