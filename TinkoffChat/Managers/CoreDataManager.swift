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
    
    func addChannel(id identifier: String, name: String, message: String?, date: Date?) {
        self.coreDataStack.performSave { context in
            _ = Channel_db(identifier: identifier,
                           name: name,
                           lastMessage: message,
                           lastActivity: date,
                           in: context)
        }
    }
    
    func updateChannel(id identifier: String, name: String, message: String?, date: Date?) {
        let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        let predicate = NSPredicate(format: "identifier = %@", identifier)
        fetchRequest.predicate = predicate
        
        coreDataStack.performSave { context in
            let result = try? context.fetch(fetchRequest)
            if let channel = result?.first {
                if channel.value(forKey: "name") as? String != name {
                    channel.setValue(name, forKey: "name")
                }
                
                if channel.value(forKey: "lastMessage") as? String != message {
                    channel.setValue(message, forKey: "lastMessage")
                }
                
                if channel.value(forKey: "lastActivity") as? Date != date {
                    channel.setValue(date, forKey: "lastActivity")
                }
            }
        }
    }
    
    func deleteChannel(channelId: String) {
        let context = coreDataStack.mainContext
        let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)
        
        let result = try? context.fetch(fetchRequest)
        if let channel = result?.first {
            context.delete(channel)
            
            do {
                try coreDataStack.mainContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addMessage(channelId: String, messageId: String, senderId: String,
                    senderName: String, content: String, created: Date) {
        let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)
        
        coreDataStack.performSave { context in
            let result = try? context.fetch(fetchRequest)
            if let channel = result?.first {
                let message = Message_db(identifier: messageId,
                                         senderId: senderId,
                                         senderName: senderName,
                                         content: content,
                                         created: created,
                                         in: context)
                message.channel = channel
//                channel.addToMessages(message)
            }
        }
    }
//
//    func saveMessages(id channelId: String, array messagesArray: [Message]) {
//        saveCDQueue.async {
//            self.coreDataStack.performSave { context in
//                let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
//                fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)
//
//                let result = try? context.fetch(fetchRequest)
//                if let channel = result?.first {
//                    messagesArray.forEach { message in
//                        let dbMessage = Message_db(identifier: message.identifier,
//                                                   senderId: message.senderId,
//                                                   senderName: message.senderName,
//                                                   content: message.content,
//                                                   created: message.created,
//                                                   in: context)
//                        channel.addToMessages(dbMessage)
//                    }
//                }
//            }
//        }
//    }
}
