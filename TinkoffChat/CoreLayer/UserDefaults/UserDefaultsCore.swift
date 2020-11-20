//
//  UserDefaultsCore.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 20.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol IUserDefaultsCore {
    var userDefaults: UserDefaults { get }
    func getValueToKey(key: String, completion: @escaping (String?) -> Void)
    func setValueToKey(value: String, key: String)
}

class UserDefaultsCore: IUserDefaultsCore {
    lazy var userDefaults: UserDefaults = {
        let userDefaults = UserDefaults.standard
        return userDefaults
    }()
    
    func getValueToKey(key: String, completion: @escaping (String?) -> Void) {
        let value = userDefaults.string(forKey: key)
        completion(value)
    }
    
    func setValueToKey(value: String, key: String) {
        userDefaults.set(value, forKey: key)
    }
}
