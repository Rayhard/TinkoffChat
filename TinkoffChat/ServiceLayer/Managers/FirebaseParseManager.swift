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
    
    private lazy var coreDataManager = CoreDataManager()
    
    func parseNewChannel(diff: DocumentChange) {
        let channel = diff.document.data()
        
        guard let name = channel["name"] as? String,
              let lastMessage = channel["lastMessage"] as? String ?? "",
              let lastActivity = channel["lastActivity"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0)),
              name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        else { return }
        
        coreDataManager.addChannel(id: diff.document.documentID,
                                   name: name,
                                   message: lastMessage,
                                   date: lastActivity.dateValue())
    }
    
    func parseUpdateChannel(diff: DocumentChange) {
        let channel = diff.document.data()
        
        guard let name = channel["name"] as? String,
              let lastMessage = channel["lastMessage"] as? String ?? "",
              let lastActivity = channel["lastActivity"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0)),
              name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        else { return }
        
        coreDataManager.updateChannel(id: diff.document.documentID,
                                      name: name,
                                      message: lastMessage,
                                      date: lastActivity.dateValue())
    }
    
    func parseNewMessage(channelId: String, diff: DocumentChange) {
        let message = diff.document.data()
        
        guard let content = message["content"] as? String,
              let senderId = message["senderId"] as? String,
              let senderName = message["senderName"] as? String,
              let created = message["created"] as? Timestamp,
              content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false,
              senderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        else { return }
        
        coreDataManager.addMessage(channelId: channelId, messageId: diff.document.documentID, senderId: senderId,
                                   senderName: senderName, content: content, created: created.dateValue())
    }
}
