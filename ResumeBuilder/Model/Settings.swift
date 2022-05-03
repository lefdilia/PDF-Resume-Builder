//
//  Settings.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 10/3/2022.
//

import UIKit


struct Section {
    var title: String
    var options: [SettingsOptionType]
}

enum SettingsOptionType {
    case staticOptions(model: StaticSettings)
    case switchOptions(model: SwitchSettings)
}

struct SwitchSettings {
    let title: String
    let slogan: String?
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (()->Void)
    var _values: String
}

struct StaticSettings {
    let title: String
    let slogan: String?
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    var _values: SettingLinks
    let handler: (()->Void)
}
