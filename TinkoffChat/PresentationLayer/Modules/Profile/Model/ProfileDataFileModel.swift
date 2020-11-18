//
//  ProfileDataFileModel.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 08.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol IProfileModel {
    func loadGCD() -> ProfileInfo
    func saveGCD(profile: ProfileInfo)
    
    func loadOperation() -> ProfileInfo
    func saveOperation(profile: ProfileInfo)
}

class ProfileModel: IProfileModel {
    weak var delegate: IDataFileServiceDelegate?
    let gcdService: IDataFileService
    let operationService: IDataFileService
    
    init(dataService: IDataFileService, operationService: IDataFileService) {
        self.gcdService = dataService
        self.operationService = operationService
    }
    
    func loadGCD() -> ProfileInfo {
        return gcdService.fetchData {
            self.delegate?.loadComplited()
        }
    }
    
    func saveGCD(profile: ProfileInfo) {
        gcdService.saveData(profile) {
            self.delegate?.saveComplited()
        }
    }
    
    func loadOperation() -> ProfileInfo {
        operationService.fetchData {
            self.delegate?.loadComplited()
        }
    }
    
    func saveOperation(profile: ProfileInfo) {
        operationService.saveData(profile) {
            self.delegate?.saveComplited()
        }
    }
}
