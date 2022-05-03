//
//  AppConfig.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 6/3/2022.
//

import Foundation

enum SettingLinks: String {
    case termsAndConditions = "https://www.lefdilia.com/resumebuilder/terms-conditions"
    case privacyPolicy = "https://www.lefdilia.com/resumebuilder/privacy-policy"
    case linkedin = "https://www.linkedin.com/in/lefdilia/"
    case portfolio = "https://www.lefdilia.com/"
}

class userDefaultKeys {
    let _SettingsKey = "Settings"
    let _SettingsDefault: [String: Any] = [
        "language": "English"
    ]
}

class defaultData {
    let languages = ["English", "French", "German", "Spanish"]
}

struct AppConfig {
    static let appData = defaultData()
    static let appKeys = userDefaultKeys()
}
