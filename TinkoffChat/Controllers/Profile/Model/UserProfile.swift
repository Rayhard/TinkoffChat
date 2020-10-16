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
    
    var name: String = "Nikita Perezhogin"
    var symbols: String = "NP"
    var description: String = "iOS Developer, QA Engener\nMoscow, Russia"
    var photo: UIImage?
}
