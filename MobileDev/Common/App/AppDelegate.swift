//
//  AppDelegate.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 09.02.2021.
//

import UIKit
import IQKeyboardManagerSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        App.setup()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = UIStoryboard.main.instantiateInitialViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
