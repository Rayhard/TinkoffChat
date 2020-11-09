//
//  ConversationsListModel.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 06.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation
import CoreData

protocol IConversListModel {
    var delegate: IConversListModelDelegate? { get set }
    func fetchChannels()
    func removeChannel(channel: Channel_db)
    func createNewChannel(name: String)
    
    func context() -> NSManagedObjectContext
    
    func loadUserInfo() -> ProfileInfo
}

protocol IConversListModelDelegate: class {
    func loadComplited()
}

class ConversListModel: IConversListModel {
    weak var delegate: IConversListModelDelegate?
    
    let firebaseService: IFirebaseService
    let coreDataService: ICoreDataService
    let dataService: IDataFileService
    
    init(firebaseService: IFirebaseService, coreDataService: ICoreDataService, dataService: IDataFileService) {
        self.firebaseService = firebaseService
        self.coreDataService = coreDataService
        self.dataService = dataService
    }
    
    func fetchChannels() {
        firebaseService.getChannels {
            self.delegate?.loadComplited()
        }
    }
    
    func removeChannel(channel: Channel_db) {
        firebaseService.deleteChannel(channel: channel)
    }
    
    func createNewChannel(name: String) {
        firebaseService.createNewChannel(name: name)
    }
    
    func context() -> NSManagedObjectContext {
        return coreDataService.getContext()
    }
    
    func loadUserInfo() -> ProfileInfo {
        return dataService.fetchData { }
    }
}
