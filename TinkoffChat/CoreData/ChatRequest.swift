//
//  ChatRequest.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation
//import CoreData

struct ChatRequest {
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func makeRequest() {
        coreDataStack.performSave { context in
            let message1 = Message_db(senderId: "123", senderName: "Nik", content: "Prrrivet", created: Date(), in: context)
            let message2 = Message_db(senderId: "123", senderName: "Nik", content: "Prrrivet 1111", created: Date(), in: context)
            let message3 = Message_db(senderId: "321", senderName: "JoJo", content: "Prrrivet 2222", created: Date(), in: context)
            let message4 = Message_db(senderId: "321", senderName: "JoJo", content: "Prrrivet 3333", created: Date(), in: context)
            
            let nik = Channel_db(identifier: "qwerty", name: "nameChannel", lastMessage: nil, lastActivity: nil, in: context)
            [message1, message2].forEach { nik.addToMessages($0) }
            
            let mike = Channel_db(identifier: "neQWERTY", name: "MikeChannel", lastMessage: nil, lastActivity: nil, in: context)
            [message3, message4].forEach { mike.addToMessages($0) }
        }
    }
}
