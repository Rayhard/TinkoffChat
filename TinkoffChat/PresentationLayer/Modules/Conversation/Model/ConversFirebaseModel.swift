//
//  ConversFirebaseModel.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 07.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation
import CoreData

protocol IConversFirebaseModel {
    var delegate: IConversFirebaseModelDelegate? { get set }
    func fetchMessages(id channelId: String)
    func sendMessage(id channelId: String, text: String)
    
    func context() -> NSManagedObjectContext
}

protocol IConversFirebaseModelDelegate: class {
    func loadComplited()
}

class ConversFirebaseModel: IConversFirebaseModel {
    var delegate: IConversFirebaseModelDelegate?
    
    let firebaseService: IFirebaseService
    let coreDataService: ICoreDataService
    
    init(firebaseService: IFirebaseService, coreDataService: ICoreDataService) {
        self.firebaseService = firebaseService
        self.coreDataService = coreDataService
    }
    
    func fetchMessages(id channelId: String) {
        firebaseService.getMessages(channelId: channelId) {
            self.delegate?.loadComplited()
        }
    }
    
    func sendMessage(id channelId: String, text: String) {
        firebaseService.sendMessage(channelId: channelId, message: text)
    }
    
    func context() -> NSManagedObjectContext {
        return coreDataService.getContext()
    }
    
}
