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
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigation = rootAssembly.presentationAssembly.mainNavigationController()
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        let animationGesture = UILongPressGestureRecognizer(target: self, action: #selector(startAnimation(tapgesture:)))
        window?.addGestureRecognizer(animationGesture)
        
        return true
    }
    
    @objc func startAnimation(tapgesture: UILongPressGestureRecognizer) {
        let emitterManager = EmitterLayerAnimator(gesture: tapgesture)
        emitterManager.startAnimation()
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
