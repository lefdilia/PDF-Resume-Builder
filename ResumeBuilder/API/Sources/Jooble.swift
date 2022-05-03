//
//  Jooble.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 21/11/2021.
//

import Foundation

struct JoobleRequestParameters: Codable {
    var keywords: String
    var location: String
    var page: Int
}

struct JoobleResult: Codable {
    var totalCount: Int
    var jobs: [JoobleJobs]
}

struct JoobleJobs: Codable, JobMapper {
    
    var job: Job {
        Job(title: title,
            location: location,
            jobDetails: jobDetails,
            applylink: applylink,
            extraInfos: extraInfos,
            type: type,
            company: company,
            source: source,
            posted: posted)
    }
    
    var title: String
    var location: String
    var jobDetails: String
    var applylink: URL?
    var type: JobType
    var extraInfos: [String: String]
    var company: Company
    var source: JobSource
    var posted: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case location
        case jobDetails = "snippet"
        case source = "source"
        case applylink = "link"
        case company
        case posted = "updated"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        location = try container.decode(String.self, forKey: .location)
        jobDetails = try container.decode(String.self, forKey: .jobDetails)
        jobDetails = try container.decode(String.self, forKey: .jobDetails)
        
        let parsedSource = try container.decode(String.self, forKey: .source).components(separatedBy: ".")
        var rawValue = parsedSource.count > 2 ? parsedSource[parsedSource.count-2] : parsedSource[0]
        rawValue = rawValue.lowercased()
        
        source = JobSource(rawValue: rawValue) ?? .none
        
        let applylink = try container.decode(String.self, forKey: .applylink)
        self.applylink = URL(string: applylink)
        
        let companyName = try container.decode(String.self, forKey: .company)
        let companyModel = Company(name: companyName, logo: nil, infos: [:])
        company = companyModel
        
        type = location.lowercased() == "remote" ? .Remote : .Onsite
        extraInfos = [:]
        
        let dateFromJson = try container.decode(String.self, forKey: .posted)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        posted = formatter.date(from: dateFromJson) ?? Date()
    }
}

class Jooble {
    
    func fetch(filters: JobSearchFilters? = nil,_ _page: Int = 1, completion: @escaping (Result<[Job], Error>) -> Void ) {
        
        
        let keyword: String = filters?.keyword ?? ""
        let location: String = filters?.location ?? "united+states"
        
        if !["united states", "usa"].contains(location) {
            return completion(.success([]))
        }
        
        let APILink = API.Jooble.endPoint + API.Jooble.appKey
        
        guard let url = URL(string: APILink) else {
            return completion(.failure(NetworkError.badUrl))
        }
        
        let parameters = JoobleRequestParameters(keywords: keyword, location: location, page: _page)
        let codedParameters = try? JSONEncoder().encode(parameters)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = codedParameters
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                return completion(.failure(NetworkError.badResponse))
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedJobs = try decoder.decode(JoobleResult.self, from: data)
                let returnedJobs = decodedJobs.jobs.map { $0.job }
                
                return completion(.success(returnedJobs))
                
            }catch{
                return completion(.failure(NetworkError.invalidDecode))
            }
        }
        task.resume()
    }
}

