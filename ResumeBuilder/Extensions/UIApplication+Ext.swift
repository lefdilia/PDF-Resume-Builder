//
//  UIApplication+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 7/11/2021.
//

import UIKit

extension UIApplication {
    
    func hideOnBoarding(_ status: Bool = false) -> Bool {
        
        let defaults = UserDefaults.standard
        let key = defaults.bool(forKey: "LunchedBeforeStatus")
        
        if status == true {
            defaults.set(true, forKey: "LunchedBeforeStatus")
            defaults.synchronize()
            return true
        }

        return key
        
    }
    
}
