//
//  ProfileDataFileModel.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 08.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol IProfileDataFileModel {
    func loadData() -> ProfileInfo
    func saveData(profile: ProfileInfo)
}

class ProfileDataFileModel: IProfileDataFileModel {
    weak var delegate: IDataFileServiceDelegate?
    let dataService: IDataFileService
    
    init(dataService: IDataFileService) {
        self.dataService = dataService
    }
    
    func loadData() -> ProfileInfo {
        return dataService.fetchData {
            self.delegate?.loadComplited()
        }
    }
    
    func saveData(profile: ProfileInfo) {
        dataService.saveData(profile) {
            self.delegate?.saveComplited()
        }
    }
}
