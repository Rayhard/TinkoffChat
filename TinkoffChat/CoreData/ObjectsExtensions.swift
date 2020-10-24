//
//  ObjectsExtensions.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation
import CoreData

extension Channel_db {
    convenience init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
}

extension Message_db {
    convenience init(senderId: String, senderName: String, content: String, created: Date,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.senderId = senderId
        self.senderName = senderName
        self.content = content
        self.created = created
    }
}
