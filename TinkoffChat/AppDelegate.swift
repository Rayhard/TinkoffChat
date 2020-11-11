//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 11.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let userDefaults = UserDefaults.standard
        setUserProfile(userDefaults: userDefaults)
        setTheme(userDefaults: userDefaults)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigation = rootAssembly.presentationAssembly.mainNavigationController()
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func setTheme(userDefaults: UserDefaults) {
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
    }
    
    private func setUserProfile(userDefaults: UserDefaults) {
        let sender = userDefaults.string(forKey: "senderId")
        if sender == nil {
            let senderId = "\(UUID())"
            userDefaults.set(senderId, forKey: "senderId")
            
            let profile = ProfileInfo(name: "Name Surname",
                                      description: "You description",
                                      photo: UIImage(named: "clearFile"))
            let dataManager = GCDDataManager(fileCore: FileManagerCore())
            dataManager.saveData((profile)) { }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}
