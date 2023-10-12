//
//  AppDelegate.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import UIKit

protocol LifecycleDelegate: AnyObject {
    func enterBackground()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    weak var delegate: LifecycleDelegate?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { 
        let _ = BackgroundScanManager.shared
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navVC = UINavigationController()
        navVC.setNavigationBarHidden(true, animated: false)
        navVC.viewControllers = [
            MainViewController()
        ]
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.delegate?.enterBackground()
    }
}

