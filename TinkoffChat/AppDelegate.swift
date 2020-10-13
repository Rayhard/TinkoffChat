//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 11.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LogManager.showMessage("Application moved from <Not running> to <Inactive>: " + #function)
        
        let userDefaults = UserDefaults.standard
        let theme = userDefaults.string(forKey: "Theme")
        
        switch theme {
        case "classic":
            Theme.current = ClassicTheme()
        case "day":
            Theme.current = DayTheme()
        case "night":
            Theme.current = NightTheme()
        default:
            Theme.current = ClassicTheme()
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        LogManager.showMessage("Application moved from <Inactive> to <Active>: " + #function)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        LogManager.showMessage("Application moved from <Active> to <Inactive>: " + #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        LogManager.showMessage("Application moved from <Inactive> to <Background>: " + #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        LogManager.showMessage("Application moved from <Background> to <Inactive>: " + #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        LogManager.showMessage("Application moved from <Suspended> to <Not running>: " + #function)
    }
}

