//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 25.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    private let saveCDQueue = DispatchQueue(label: "CoreDataManager_Save", qos: .default, attributes: .concurrent)
    
    func saveChannels(array channelsArray: [Channel], in coreDataStack: CoreDataStack) {
        saveCDQueue.async {
            coreDataStack.performSave { context in
                channelsArray.forEach { channel in
                    let channel = Channel_db(identifier: channel.identifier,
                                               name: channel.name,
                                               lastMessage: channel.lastMessage,
                                               lastActivity: channel.lastActivity,
                                               in: context)
                }
            }
        }
    }
    
    func saveMessages(id channelId: String, array messagesArray: [Message], in coreDataStack: CoreDataStack) {
        saveCDQueue.async {
            coreDataStack.performSave { context in
                messagesArray.forEach { message in
                    let dbMessage = Message_db(senderId: message.senderId,
                                               senderName: message.senderName,
                                               content: message.content,
                                               created: message.created,
                                               in: context)
                }
            }
        }
    }
}
