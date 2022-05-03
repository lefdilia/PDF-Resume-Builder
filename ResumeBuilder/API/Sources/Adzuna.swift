//
//  Adzuna.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 25/11/2021.
//

import Foundation


var AdzunaCountries: [String:String]? = ["austria": "at","australia": "au","belgium": "be","brazil": "br","canada": "ca","switzerland": "ch","germany": "de","spain": "es","france": "fr","united kingdom": "gb","uk": "gb","india": "in","italy": "it","mexico": "mx","netherlands": "nl","new zealand": "nz","poland": "pl","russia": "ru","singapore": "sg","united states": "us","usa": "us","south africa": "za"
]

struct AdzunaResult: Decodable {
    var results: [AdzunaJobs]
}

//struct AdzunaCompany: Decodable {
//    let companyName: String
//
//    enum CodingKeys: String, CodingKey {
//        case companyName = "display_name"
//    }
//}

struct AdzunaCategory: Decodable {
    let industry: String
    let reference: String
    
    enum CodingKeys: String, CodingKey {
        case industry = "label"
        case reference = "tag"
    }
}

struct AdzunaLocation: Decodable {
    let companyName: String
    let area: [String]
    
    enum CodingKeys: String, CodingKey {
        case area
        case companyName = "display_name"
    }
}

struct AdzunaJobs: Decodable, JobMapper {
    let title: String
    var location: String
    let jobDetails: String
    let applylink: URL?
    var type: JobType
    var extraInfos: [String: String]
    let company: Company
    var source: JobSource
    let posted: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case location
        case company
        case applylink = "redirect_url"
        case jobDetails = "description"
        case posted = "created"
        case category = "category"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let infos = try container.decode(AdzunaCategory.self, forKey: .category)
        extraInfos = ["industry": infos.industry.capitalized, "reference": infos.reference.capitalized]
        
        let _location = try container.decode(AdzunaLocation.self, forKey: .location)
        company = Company(name: _location.companyName, logo: nil, infos: [:])
        location = _location.area.reversed().joined(separator: ", ")

        title = try container.decode(String.self, forKey: .title)
        
        let applylink = try container.decode(String.self, forKey: .applylink)
        self.applylink = URL(string: applylink)
        
        jobDetails = try container.decode(String.self, forKey: .jobDetails)
        
        let dateFromJson = try container.decode(String.self, forKey: .posted)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        posted = formatter.date(from: dateFromJson) ?? Date()
        
        source = .adzuna
        if let _ = jobDetails.range(of: "remote", options: .caseInsensitive) {
            type = .Remote
        }else{
            type = .Onsite
        }
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



class Adzuna {
    
    func fetch(filters: JobSearchFilters? = nil,_ _page: Int = 1, completion: @escaping (Result<[Job], Error>) -> Void ) {
        
        let keyword: String = filters?.keyword ?? ""
        let location: String = filters?.location?.lowercased() ?? ""
        
        let limitPerPage = API.Adzuna.limitPerPage
        
        guard let countryCode = AdzunaCountries?[location] else {
            return completion(.success([]))
        }
        
        let APILink = [API.Adzuna.endPoint, "/", countryCode, "/search/", String(_page), "?app_id=", API.Adzuna.appId, "&app_key=",API.Adzuna.appKey, "&results_per_page=", String(limitPerPage), "&what=", keyword, "&content-type=application/json" ].joined(separator: "")
        
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
                let decodedJobs = try decoder.decode(AdzunaResult.self, from: data)
                let returnedJobs = decodedJobs.results.map { $0.job }
                
                return completion(.success(returnedJobs))
                
            }catch{
                return completion(.failure(NetworkError.invalidDecode))
            }
        }
        task.resume()
    }
    
}

