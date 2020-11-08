//
//  ConversListDataManagerModel.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 07.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol IConversListDataFileModel {
    func loadData() -> ProfileInfo
}

class ConversListDataFileModel: IConversListDataFileModel {
    let dataService: IDataFileService
    
    init(dataService: IDataFileService) {
        self.dataService = dataService
    }
    
    func loadData() -> ProfileInfo {
        return dataService.fetchData { }
    }
}
