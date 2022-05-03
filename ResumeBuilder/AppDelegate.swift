//
//  AppDelegate.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 3/11/2021.
//

import Firebase
import UIKit
import UserNotifications


@main
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        //Init Firebase
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        
        //Remote Notification / Messaging Config
        UNUserNotificationCenter.current().delegate = self

        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, _ in
            guard token != nil else { return }
        }
                
        //Clear App badges
        if application.applicationIconBadgeNumber > 0 {
            application.applicationIconBadgeNumber = 0
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
        
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.tabBarItem.tag == 2 {
            let addResumeViewController = UINavigationController(rootViewController: AddResumeViewController())
            addResumeViewController.modalPresentationStyle = .overFullScreen
            addResumeViewController.modalTransitionStyle = .coverVertical
            addResumeViewController.setNavigationBarHidden(true, animated: true)
            tabBarController.present(addResumeViewController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

