//
//  FirebaseParseManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 20.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation
import Firebase

class FirebaseParseManager {
    func parseChannel(_ snapshot: QuerySnapshot?) -> [Channel] {
        var channelsArray: [Channel] = []
        guard let channels = snapshot else { return channelsArray }

        for document in channels.documents {
            let channel = document.data()
            
            guard let name = channel["name"] as? String,
                  let lastMessage = channel["lastMessage"] as? String ?? "",
                  let lastActivity = channel["lastActivity"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
            else { continue }
            
            let newChannel = Channel(indetifier: document.documentID,
                                  name: name,
                                  lastMessage: lastMessage,
                                  lastActivity: lastActivity.dateValue())

            channelsArray.append(newChannel)
        }
        return channelsArray
    }
    
    func parseMessage(_ snapshot: QuerySnapshot?) -> [Message] {
        var messagesArray: [Message] = []
        guard let messages = snapshot else { return messagesArray }
        
        for message in messages.documents {
            
            guard let content = message["content"] as? String,
                  let senderId = message["senderId"] as? String,
                  let senderName = message["senderName"] as? String,
                  let created = message["created"] as? Timestamp
            else { continue }

            let newMessage = Message(content: content,
                                     created: created.dateValue(),
                                     senderId: senderId,
                                     senderName: senderName)
            
            messagesArray.append(newMessage)
        }
        return messagesArray
    }
}
