//
//  SettingsService.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 20.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

protocol ISettingsService {
    func setTheme()
    func setProfile()
}

class SettingsService: ISettingsService {
    private let userDefaults: IUserDefaultsCore
    private let fileManager: IDataFileService
    
    init(userDefaults: IUserDefaultsCore, fileManager: IDataFileService) {
        self.userDefaults = userDefaults
        self.fileManager = fileManager
    }
    
    func setTheme() {
        userDefaults.getValueToKey(key: "Theme") { userTheme in
            guard let theme = userTheme
            else {
                Theme.current = ClassicTheme()
                return
            }
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
    }
    
    func setProfile() {
        userDefaults.getValueToKey(key: "senderId") { sender in
            if sender == nil {
                let senderId = "\(UUID())"
                self.userDefaults.setValueToKey(value: senderId, key: "senderId")
                
                let profile = ProfileInfo(name: "Name Surname",
                                          description: "You description",
                                          photo: UIImage(named: "clearFile"))
                
                self.fileManager.saveData(profile) {
                    //
                }
            }
        }
    }
}
