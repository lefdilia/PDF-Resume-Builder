//
//  Reed.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 29/11/2021.
//

import Foundation



struct ReedResult: Decodable {
    let totalResults: Int
    let results: [ReedJobs]
}

struct ReedJobs: Decodable {
    
    let title: String
    let location: String
    let jobDetails: String
    let applylink: URL?
    let type: JobType
    var extraInfos: [String: String]
    let company: Company
    var source: JobSource
    let posted: Date
    
    enum CodingKeys: String, CodingKey {
        case title = "jobTitle"
        case location = "locationName"
        case jobDetails = "jobDescription"
        case applylink = "jobUrl"
        case company = "employerName"
        case posted = "date"
        
        case minSalary = "minimumSalary"
        case maxSalary = "maximumSalary"
        case currency = "currency"
        case dueDate = "expirationDate"
        case applications = "applications"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        
        location = try container.decode(String.self, forKey: .location)
        
        jobDetails = try container.decode(String.self, forKey: .jobDetails)
        
        source = .reed
        if let _ = jobDetails.range(of: "remote", options: .caseInsensitive) {
            type = .Remote
        }else{
            type = .Onsite
        }
        
        //MARK: - Build Extra Infos
        extraInfos = [:]
        //
        let minSalary = try container.decode(Double?.self, forKey: .minSalary)
        let maxSalary = try container.decode(Double?.self, forKey: .maxSalary)
        let currency = try container.decode(String?.self, forKey: .currency)
        if minSalary != nil || maxSalary != nil {
            extraInfos["Salary"] = "\(Int(minSalary ?? 0.0)) - \(Int(maxSalary ?? 0.0)) \(String(describing: currency ?? "GBP"))"
        }
        //
        let dueDate = try container.decode(String?.self, forKey: .dueDate)
        extraInfos["dueDate"] = dueDate
        //
        let applications = try container.decode(Int?.self, forKey: .applications)
        if let applications = applications {
            if applications > 0 {
                extraInfos["Estimated Applications"] = String(describing: applications)
            }
        }
        //MARK: - End
        
        let applylink = try container.decode(String.self, forKey: .applylink)
        self.applylink = URL(string: applylink)
        
        let employerName = try container.decode(String.self, forKey: .company)
        self.company = Company(name: employerName, logo: nil, infos: [:])
        
        let dateFromJson = try container.decode(String.self, forKey: .posted)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        posted = formatter.date(from: dateFromJson) ?? Date()
        
        
    }
    
    
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
    
}


class Reed {
    
    func fetch(filters: JobSearchFilters? = nil, _ page: Int = 1, completion: @escaping (Result<[Job], Error>) -> Void ) {
        
        let keyword: String = filters?.keyword ?? ""
        var location: String = filters?.location?.lowercased() ?? ""
        
        //Fix Country spell
        if location == "united states" {
            location = "usa"
        }
        
        let limit = API.Reed.limitPerPage
        
        let resultsToSkip = limit * (page - 1)
        
        let APILink = [API.Reed.endPoint, "?", "keywords=", keyword, "&locationName=", location, "&resultsToTake=", String(limit), "&resultsToSkip=", String(resultsToSkip) ].joined(separator: "")
        
        guard let url = URL(string: APILink) else {
            return completion(.failure(NetworkError.badUrl))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(API.Reed.authKey, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                return completion(.failure(NetworkError.badResponse))
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedJobs = try decoder.decode(ReedResult.self, from: data)
                let returnedJobs = decodedJobs.results.map { $0.job }
                
                return completion(.success(returnedJobs))
                
            }catch{
                return completion(.failure(NetworkError.invalidDecode))
            }
        }
        task.resume()
    }
}

