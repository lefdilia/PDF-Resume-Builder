//
//  Onboarding.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 4/11/2021.
//

import Foundation

struct Onboarding {
    
    var screenImage: String
    var headerText: String
    var bodyText: String
    
    static func getScreens() -> [Onboarding] {

        let screens = [
            Onboarding(screenImage: "Screen-1", headerText: "1. Create Resume", bodyText: "Create a modern resume with the simplest builder app. Your professional resume will be ready in minutes."),
            Onboarding(screenImage: "Screen-2", headerText: "2. Fill the sections", bodyText: "We will guide you through the process of writing each section fast & easy."),
            Onboarding(screenImage: "Screen-3", headerText: "3. Export Resume", bodyText: "Download the finished document to share it during your application process or save it in PDF format."),
            Onboarding(screenImage: "Screen-4", headerText: "4. Apply for Jobs", bodyText: "Search for a job directly from the app, through famous API's like: \n `Reed UK`, `USA Jobs`,...")
        ]
        
        return screens
    }
    
}
