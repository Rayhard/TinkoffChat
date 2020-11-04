//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 25.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    private let saveCDQueue = DispatchQueue(label: "CoreDataManager_Save", qos: .default, attributes: .concurrent)
    private let coreDataStack: CoreDataStack = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let delegate = appDelegate else { return CoreDataStack()}
        return delegate.coreDataStack
    }()
    
    func saveChannels(array channelsArray: [Channel]) {
        saveCDQueue.async {
            self.coreDataStack.performSave { context in
                channelsArray.forEach { channel in
                    _ = Channel_db(identifier: channel.identifier,
                                   name: channel.name,
                                   lastMessage: channel.lastMessage,
                                   lastActivity: channel.lastActivity,
                                   in: context)
                }
            }
        }
    }
    
    func deleteChannel(channel: Channel_db) {
        coreDataStack.mainContext.delete(channel)
        
        do {
            try coreDataStack.mainContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveMessages(id channelId: String, array messagesArray: [Message]) {
        saveCDQueue.async {
            self.coreDataStack.performSave { context in
                let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)
                
                let result = try? context.fetch(fetchRequest)
                if let channel = result?.first {
                    messagesArray.forEach { message in
                        let dbMessage = Message_db(identifier: message.identifier,
                                                   senderId: message.senderId,
                                                   senderName: message.senderName,
                                                   content: message.content,
                                                   created: message.created,
                                                   in: context)
                        channel.addToMessages(dbMessage)
                    }
                }
            }
        }
    }
}
