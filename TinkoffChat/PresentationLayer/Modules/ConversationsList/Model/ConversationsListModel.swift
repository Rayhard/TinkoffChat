//
//  ConversationsListModel.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 06.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol IConversListFirebaseModel {
    var delegate: IConversListFirebaseModelDelegate? { get set }
    func fetchChannels()
    func removeChannel(channel: Channel_db)
    func createNewChannel(name: String)
}

protocol IConversListFirebaseModelDelegate: class {
    func loadComplited()
}

class ConversListFirebaseModel: IConversListFirebaseModel {
    weak var delegate: IConversListFirebaseModelDelegate?
    let firebaseService: IFirebaseService
    
    init(firebaseService: IFirebaseService) {
        self.firebaseService = firebaseService
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
}
