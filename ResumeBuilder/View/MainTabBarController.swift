//
//  MainTabBarController.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 5/11/2021.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    var activeTabConstraint: NSLayoutConstraint!
    var lineWidthConstraint: NSLayoutConstraint!
    
    var calculatedPosition: CGFloat = 0.0

     let lineView: UIView = {
        let lineView = UIView()
        lineView.accessibilityLabel = "lineView"
        lineView.backgroundColor = .tundora
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //Present AddResume VC Modaly
        self.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        
        viewControllers = [
            createNavViewController(viewController: HomeViewController(), title: "Home", imageName: "Home", tag: 0),
            createNavViewController(viewController: ExploreViewController(), title: "Explore", imageName: "Explore", tag: 1),
            createNavViewController(viewController: AddResumeViewController(), title: " ", imageName: "AddResume", tag: 2),
            createNavViewController(viewController: JobsViewController(), title: "Jobs", imageName: "Jobs", tag: 3),
            createNavViewController(viewController: SettingsViewController(), title: "Settings", imageName: "Settings", tag: 4)
        ]

        tabBar.isTranslucent = false
        tabBar.tintColor = .apTintColor
        
        //Fix Separator and Color for the tabBar (IOS 15)
        if #available(iOS 15, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .apBackground
            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }

        //Delay Notification request POP after swipingove Onboarding
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: { _, _ in })
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
  
    private func createNavViewController(viewController: UIViewController, title: String, imageName: String, tag: Int) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.title = title
        navController.tabBarItem.image = (tag == 2) ? UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal) : UIImage(named: imageName)
        navController.tabBarItem.tag = tag
        
        return navController
    }

    
}


