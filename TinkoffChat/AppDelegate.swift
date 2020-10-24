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
    
    var coreDataStack = CoreDataStack()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        LogManager.showMessage("Application moved from <Not running> to <Inactive>: " + #function)
        
        setCoreData()
        
        let userDefaults = UserDefaults.standard
        setUserProfile(userDefaults: userDefaults)
        setTheme(userDefaults: userDefaults)
        
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
        let launchedBefore = userDefaults.bool(forKey: "launchedBefore")
        if launchedBefore == false {
            userDefaults.set(true, forKey: "launchedBefore")
            
            let senderId = "\(UUID())"
            userDefaults.set(senderId, forKey: "senderId")
            
            let profile = ProfileInfo(name: "Name Surname",
                                      description: "You description",
                                      photo: UIImage(named: "clearFile"))
            let dataManager = GCDDataManager()
            dataManager.saveData(profile)
        }
    }
    
    private func setCoreData() {
        coreDataStack.didUpdateDatease = { stack in
            stack.printDataBaseStats()
        }
        
        coreDataStack.enableObservers()
        
//        let chatRequest = ChatRequest(coreDataStack: coreDataStack)
//        chatRequest.makeRequest()
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
