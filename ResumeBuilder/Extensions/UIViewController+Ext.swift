//
//  UIViewController+Ext.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 16/2/2022.
//

import UIKit

extension UIViewController {
    
    //MARK: - POP Multiple Viewcontroller
    func popTo<T>(_ vc: T.Type) -> Bool? {
        let targetVC = navigationController?.viewControllers.first{$0 is T}
        if let targetVC = targetVC {
            navigationController?.popToViewController(targetVC, animated: true)
            return true
        }
        return false
    }
    
    
}
