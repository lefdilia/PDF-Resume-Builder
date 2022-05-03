//
//  Job.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 8/11/2021.
//

import Foundation

struct JobSearchFilters {
    var keyword: String?
    var location: String?
}

protocol JobMapper {
    var job: Job { get }
}

enum JobType: String, Codable {
    case Remote
    case Onsite
    case Hybrid
}

enum JobSource: String, Codable {
    case jooble
    case adzuna
    case reed
    case careerJet
    case glassdoor
    case usajobs
    
    //extra
    case builtin
    case linkedin
    case ziprecruiter
    case monster
    case appcast
    case careerbuilder
    case jobget
    case thejobnetwork
    case indeed
    case jobs2careers
    case jobsinforex
    case deloitte
    case floqast
    
    case none
    
    var infos: (JobSource, String, URL?) {
        switch self {
        case .jooble:
            return (name: self, image: "jooble", url: URL(string: "https://www.jooble.com"))
        case .adzuna:
            return (name: self, image: "adzuna", url: URL(string: "https://www.adzuna.com"))
        case .reed:
            return (name: self, image: "reed", url: URL(string: "https://www.reed.co.uk"))
        case .careerJet:
            return (name: self, image: "careerjet", url: URL(string: "https://www.careerjet.com"))
        case .glassdoor:
            return (name: self, image: "glassdoor", url: URL(string: "https://www.glassdoor.com"))
        case .usajobs:
            return (name: self, image: "usajobs", url: URL(string: "https://data.usajobs.gov"))
            
            //Extra-Sources
        case .builtin:
            return (name: self, image: "builtin", url: URL(string: "https://www.builtin.com"))
        case .linkedin:
            return (name: self, image: "linkedin", url: URL(string: "https://www.linkedin.com"))
        case .ziprecruiter:
            return (name: self, image: "ziprecruiter", url: URL(string: "https://www.ziprecruiter.com"))
        case .monster:
            return (name: self, image: "monster", url: URL(string: "https://www.monster.com"))
        case .appcast:
            return (name: self, image: "appcast", url: URL(string: "https://www.appcast.io"))
        case .careerbuilder:
            return (name: self, image: "careerbuilder", url: URL(string: "https://www.careerbuilder.com"))
        case .jobget:
            return (name: self, image: "jobget", url: URL(string: "https://www.jobget.com"))
        case .thejobnetwork:
            return (name: self, image: "thejobnetwork", url: URL(string: "https://www.thejobnetwork.com"))
        case .indeed:
            return (name: self, image: "indeed", url: URL(string: "https://www.indeed.com"))
        case .jobsinforex:
            return (name: self, image: "jobsinforex", url: URL(string: "https://www.jobsinforex.com"))
        case .jobs2careers:
            return (name: self, image: "jobs2careers", url: URL(string: "https://www.jobs2careers.com"))
        case .deloitte:
            return (name: self, image: "deloitte", url: URL(string: "https://www.deloitte.com"))
        case .floqast:
            return (name: self, image: "floqast", url: URL(string: "https://www.floqast.com"))
            
            //Can't Find Any value for the source
        case .none:
            return (name: self, image: "company_logo", url: nil)
        }
    }
}

struct Company: Codable {
    var name: String
    var logo: String? // Small square Logo?
    var infos: [String: String]?
}

struct Job {
    
    var title: String // Full Stack Developer
    var location: String
    var jobDetails: String
    var applylink: URL?
    
    var extraInfos: [String: String]
    
    var type: JobType // Hybrid && Remote
    var company: Company
    var source: JobSource
    
    var posted: Date
    
}
