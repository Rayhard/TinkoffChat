//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 13.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol IDataFileService {
    func saveData(_ info: ProfileInfo, completion: @escaping () -> Void)
    func fetchData(completion: @escaping () -> Void) -> ProfileInfo
}

protocol IDataFileServiceDelegate: class {
    func saveComplited()
    func loadComplited()
}
