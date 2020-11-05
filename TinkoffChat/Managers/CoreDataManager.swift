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
        let channelFetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        channelFetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
        
        self.coreDataStack.performSave { context in
            let result = try? context.fetch(channelFetchRequest)
            let channel = result?.first
            
            if channel == nil {
                _ = Channel_db(identifier: identifier,
                               name: name,
                               lastMessage: message,
                               lastActivity: date,
                               in: context)
            } else {
                updateChannel(id: identifier,
                              name: name,
                              message: message,
                              date: date)
            }
        }
    }
    
    func updateChannel(id identifier: String, name: String, message: String?, date: Date?) {
        let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
        
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
        let channelFetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        channelFetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)
        
        let messageFetchRequest: NSFetchRequest<Message_db> = Message_db.fetchRequest()
        messageFetchRequest.predicate = NSPredicate(format: "identifier = %@", messageId)
        
        coreDataStack.performSave { context in
            let message = try? context.fetch(messageFetchRequest)
            let result = try? context.fetch(channelFetchRequest)
            if let channel = result?.first,
               message?.first == nil {
                let message = Message_db(identifier: messageId,
                                         senderId: senderId,
                                         senderName: senderName,
                                         content: content,
                                         created: created,
                                         in: context)
                channel.addToMessages(message)
            }
        }
    }
}
