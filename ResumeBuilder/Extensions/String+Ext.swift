//
//  String+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 24/11/2021.
//

import Foundation


extension String {
    
    //MARK: - Match Regex
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    //MARK: - Clear HTML
    public var withoutHtml: String {
            guard let data = self.data(using: .utf8) else {
                return self
            }

            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
            ]

            guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
                return self
            }

            return attributedString.string
        }
    
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }


    //MARK: - Translate top titles
    func localized() -> Self {
        guard let options = UserDefaults.standard.object(forKey: AppConfig.appKeys._SettingsKey) as? [String : Any] else {
            return self
        }
        
        let defaultLanguage = "English"
        
        if let language = options["language"] as? String, language != defaultLanguage {
            
            let descriptionDict: [String: [String]] = [
                "English": [
                    "Personal Info",
                    "Skills",
                    "Softwares",
                    "Languages",
                    "Summary",
                    "Work History",
                    "Education",
                    "Certifications",
                    "Accomplishments",
                    "Interests",
                    "Additional Information",
                    //
                    "Native",
                    "Proficient",
                    "Advanced",
                    "Intermediate",
                    "Beginner",
                    "Novice",
                    //
                    "phone",
                    "email",
                    "Website",
                ],
                "French": [
                    "Informations Personnelles",
                    "Comp??tences",
                    "Logiciels",
                    "Langues",
                    "Objectifs de carri??re",
                    "Exp??riences professionnelles",
                    "??ducation",
                    "Certificats",//
                    "R??alisations Professionnelles",
                    "Centres d'int??r??ts",
                    "Informations Compl??mentaires",
                    //
                    "Bilingue",
                    "Courant",
                    "Avanc??",
                    "Interm??diaire",
                    "Basique",
                    "Novice",
                    //
                    "t??l??phone",
                    "courriel",
                    "site Web",
                ],
                "German": [
                    "Pers??nliche Angaben",
                    "Kenntnisse",
                    "Software Kompetenzen",
                    "Sprachen",
                    "??ber mich",
                    "Berufliche Erfahrung",
                    "Ausbildung",
                    "Zertifizierungen",
                    "Errungenschaften",
                    "Interessen",
                    "Zus??tzliche Information",
                    //
                    "Muttersprache",
                    "Flie??end",
                    "Verhandlungssicher",
                    "Dazwischenliegend",
                    "Grundkenntnisse",
                    "Anf??nger",
                    //
                    "telefon",
                    "e-mail",
                    "Webseite",
                ],
                "Spanish": [
                    "Datos Personales",
                    "Competencias",
                    "Inform??tica",
                    "Idiomas",
                    "perfil",
                    "Experiencia Profesional",
                    "Educaci??n",
                    "Certificaciones",
                    "Logros",
                    "Inter??s",
                    "Informaci??n Adicional",
                    //
                    "Lengua materna",
                    "Profesional",
                    "Avanzado",
                    "Intermedio",
                    "B??sico",
                    "Principiante",
                    //
                    "tel??fono",
                    "email",
                    "website",
                ],
            ]
                        
            if let _stringIndex = descriptionDict["English"]?.firstIndex(of: self), let _string = descriptionDict[language]?[_stringIndex] {
                return _string
            }
            
        }
        
        return self
    }
}



