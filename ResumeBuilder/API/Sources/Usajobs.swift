//
//  Usajobs.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 26/11/2021.
//

import Foundation


struct UsajobsResult: Decodable {
    let searchResult: SearchResult
    
    enum CodingKeys: String, CodingKey {
        case searchResult = "SearchResult"
    }
}

struct SearchResult: Decodable {
    let searchResultItems: [MatchedJob]
    
    enum CodingKeys: String, CodingKey {
        case searchResultItems = "SearchResultItems"
    }
}

struct MatchedJob: Decodable {
    let item: usaJobs
    
    enum CodingKeys: String, CodingKey {
        case item = "MatchedObjectDescriptor"
    }
}

struct usaJobs: Decodable, JobMapper {
    
    let title: String
    let location: String
    let jobDetails: String
    let applylink: URL?
    let type: JobType
    var extraInfos: [String: String]
    var company: Company
    var source: JobSource
    var posted: Date
    
    enum CodingKeys: String, CodingKey {
        case title = "PositionTitle"
        case location = "PositionLocation"
        case applylink = "ApplyURI"
        
        case organization = "OrganizationName"
        case department = "DepartmentName"
        case jobCategory = "JobCategory"
        case employement = "PositionSchedule"
        case position = "PositionOfferingType"
        case qualification = "QualificationSummary"
        
        case posted = "PublicationStartDate"
        case userArea = "UserArea"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        
        let PositionLocation = try container.decode([PositionLocation].self, forKey: .location)
        self.location = PositionLocation.first?.locationName ?? ""
        
        let applylink = try container.decode([String].self, forKey: .applylink)
        self.applylink = URL(string: applylink.first ?? "")
        
        let details = try container.decode(UserArea.self, forKey: .userArea).Details
        self.jobDetails = details.jobDetailsFull.first ?? details.jobDetails
        
        self.type = .Onsite
        
        let organization = try container.decode(String.self, forKey: .organization)
        let department = try container.decode(String.self, forKey: .department)
        let jobCategory = try container.decode([JobCategory].self, forKey: .jobCategory).first?.title ?? ""
        let employement = try container.decode([PositionSchedule].self, forKey: .employement).first?.title ?? ""
        let position = try container.decode([PositionOfferingType].self, forKey: .position).first?.title ?? ""
        let qualification = try container.decode(String.self, forKey: .qualification)
        
        extraInfos = [ "organization": organization, "department": department, "category": jobCategory, "employement": employement, "position": position, "qualification": qualification
        ]
        
        self.company = Company(name: organization, logo: "usajobs", infos: nil)
        self.source = .usajobs
        
        let posted = try container.decode(String.self, forKey: .posted)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        self.posted = formatter.date(from: posted) ?? Date()
        
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

struct PositionLocation: Codable {
    let locationName: String
    enum CodingKeys: String, CodingKey {
        case locationName = "LocationName"
    }
}

struct JobCategory: Codable {
    let title: String
    enum CodingKeys: String, CodingKey {
        case title = "Name"
    }
}

struct PositionSchedule: Codable {
    let title: String
    enum CodingKeys: String, CodingKey {
        case title = "Name"
    }
}

struct PositionOfferingType: Codable {
    let title: String
    enum CodingKeys: String, CodingKey {
        case title = "Name"
    }
}

struct UserArea: Codable {
    let Details: Details
}

struct Details: Codable {
    let jobDetails: String
    let jobDetailsFull: [String]
    
    enum CodingKeys: String, CodingKey {
        case jobDetails = "JobSummary"
        case jobDetailsFull = "MajorDuties"
    }
}

class Usajobs {
    
    func fetch(filters: JobSearchFilters? = nil, completion: @escaping (Result<[Job], Error>) -> Void ) {
        
        let keyword: String = filters?.keyword ?? ""
        let location: String = filters?.location?.lowercased() ?? ""
        
        if !["united states", "usa"].contains(location) {
            return completion(.success([]))
        }
        
        let APILink = [API.Usajobs.endPoint, "Keyword=", keyword, "&SortField=ApplicationCloseDate", "&ResultsPerPage=", String(API.Usajobs.limitPerPage) ].joined(separator: "")
        
        guard let url = URL(string: APILink) else {
            return completion(.failure(NetworkError.badUrl))
        }
        
        var request = URLRequest(url: url)
        request.addValue(API.Usajobs.agent, forHTTPHeaderField: "User-Agent")
        request.addValue(API.Usajobs.host, forHTTPHeaderField: "Host")
        request.addValue(API.Usajobs.authKey, forHTTPHeaderField: "Authorization-Key")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                return completion(.failure(NetworkError.badResponse))
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedJobs = try decoder.decode(UsajobsResult.self, from: data)
                
                let refactoredJobs = decodedJobs.searchResult.searchResultItems.map { matchedJob in
                    return matchedJob.item.job
                }
                
                return completion(.success(refactoredJobs))
                
            }catch{
                return completion(.failure(NetworkError.invalidDecode))
            }
        }
        task.resume()
    }
    
}
