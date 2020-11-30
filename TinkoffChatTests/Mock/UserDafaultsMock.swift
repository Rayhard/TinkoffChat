//
//  UserDafaultsMock.swift
//  TinkoffChatTests
//
//  Created by Никита Пережогин on 30.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

@testable import TinkoffChat
import Foundation

final class UserDafaultsMock: IUserDefaultsCore {
    var saveCallsCount = 0
    var readCallsCount = 0
    
    func getValueToKey(key: String, completion: @escaping (String?) -> Void) {
        readCallsCount += 1
        completion(nil)
    }
    
    func setValueToKey(value: String, key: String) {
        saveCallsCount += 1
    }

}
