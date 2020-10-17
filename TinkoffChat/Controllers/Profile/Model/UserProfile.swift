//
//  UserProfile.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 25.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

final class UserProfile {
    private init() {}
    
    static let shared = UserProfile()
    
    var name: String = "You Name"
    var senderId: String {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: "senderId") ?? ""
    }
    var symbols: String = "NP"
    var description: String = "You description"
    var photo: UIImage?
}
