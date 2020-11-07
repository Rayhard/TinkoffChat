//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 13.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol IDataFileService {
    func saveData(_ info: ProfileInfo)
    func fetchData() -> ProfileInfo
    var delegat: IDataFileServiceDelegate? { get set }
}

protocol IDataFileServiceDelegate: class {
    func saveComplited()
    func loadComplited()
}
