//
//  Bundle+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 6/3/2022.
//

import Foundation

extension Bundle {
    var appDisplayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
    
    var appName: String? {
        return object(forInfoDictionaryKey: "CFBundleName") as? String
    }

    var appVersion: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var buildNumber: String? {
        return object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
