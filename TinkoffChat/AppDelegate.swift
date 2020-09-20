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
    var showLog: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if showLog {
            print("Application moved from <Not running> to <Inactive>: " + #function)
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        if showLog {
            print("Application moved from <Inactive> to <Active>: " + #function)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        if showLog {
            print("Application moved from <Active> to <Inactive>: " + #function)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if showLog {
            print("Application moved from <Inactive> to <Background>: " + #function)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        if showLog {
            print("Application moved from <Background> to <Inactive>: " + #function)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        if showLog {
            print("Application moved from <Suspended> to <Not running>: " + #function)
        }
    }
}

