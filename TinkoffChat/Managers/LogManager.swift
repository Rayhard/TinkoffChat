//
//  LogManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 22.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

final class LogManager{
    private init() {}
    
    static let showLog: Bool = false
    
    static func showMessage(_ text: String){
        if showLog{
            print(text)
        }
    }
}
