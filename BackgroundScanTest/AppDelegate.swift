//
//  AppDelegate.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import UIKit

protocol LifecycleDelegate: AnyObject {
    func enterBackground()
    func enterForeground()
    func didFinishLaunching()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    weak var delegate: LifecycleDelegate?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { 
        log.setupLogging()
        
        log.info("▶️ didFinishLaunchingWithOptions launchOptions = \(launchOptions)")
        
        let _ = BackgroundScanManager.shared
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navVC = UINavigationController()
        navVC.setNavigationBarHidden(false, animated: false)
        navVC.viewControllers = [
            MainViewController()
        ]
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
        
        self.delegate?.didFinishLaunching()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        log.info("🛏️ applicationDidEnterBackground")
        self.delegate?.enterBackground()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        log.info("☠️ applicationWillTerminate")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        log.info("🌅 applicationWillEnterForeground")
        
        self.delegate?.enterForeground()
    }
}


