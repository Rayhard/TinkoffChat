//
//  FirebaseDataManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 16.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit
import Firebase

class FirebaseDataManager {
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    private lazy var parseManager = FirebaseParseManager()
    
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func getChannels(completion: @escaping ([Channel]) -> Void) {
        
        DispatchQueue.global().async {
            self.reference.addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    let channelsArray = self.parseManager.parseChannel(querySnapshot)
                    
                    self.coreDataStack.performSave { context in
                        channelsArray.forEach { channel in
                            let dbChannel = Channel_db(identifier: channel.indetifier,
                                                       name: channel.name,
                                                       lastMessage: channel.lastMessage,
                                                       lastActivity: channel.lastActivity,
                                                       in: context)
                        }
                    }
                    completion(channelsArray)
                }
            }
        }
    }
    
    func createNewChannel(name: String) {
        let userName = UserProfile.shared.name
        let message = "\(userName) создал канал \(name)"
        let time = Timestamp(date: Date())
        
        let ref = reference.document()
        let id = ref.documentID
        ref.setData([
            "name": name,
            "lastMessage": message,
            "lastActivity": time
        ])
        
        reference.document(id).collection("messages").addDocument(data: [
            "content": message,
            "senderId": "",
            "senderName": "",
            "created": time
        ])
    }
    
    func getMessages(channelId: String, completion: @escaping ([Message]) -> Void) {
        let messageRef = reference.document(channelId).collection("messages")
        
        DispatchQueue.global().async {
            messageRef.addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    let messagesArray = self.parseManager.parseMessage(querySnapshot)
                    self.coreDataStack.performSave { context in
                        messagesArray.forEach { message in
                            let dbMessage = Message_db(senderId: message.senderId,
                                                       senderName: message.senderName,
                                                       content: message.content,
                                                       created: message.created,
                                                       in: context)
                        }
                    }
                    completion(messagesArray)
                }
            }
        }
    }
    
    func sendMessage(channelId: String, message: String) {
        let messageRef = reference.document(channelId).collection("messages")
        let time = Timestamp(date: Date())
        
        messageRef.addDocument(data: [
            "content": message,
            "created": time,
            "senderId": UserProfile.shared.senderId,
            "senderName": UserProfile.shared.name
        ])
    }
}
