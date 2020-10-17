//
//  DataManagerDelegate.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 13.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol DataManagerDelegate: class {
    func saveComplited()
    func loadComplited()
}
