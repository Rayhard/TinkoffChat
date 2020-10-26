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
    private lazy var coreDataManager = CoreDataManager()
    
    private let saveDBQueue = DispatchQueue(label: "FirebaseDataManager", qos: .userInitiated, attributes: .concurrent)
    
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
                    let group = DispatchGroup()
                    var channelsArray: [Channel] = []
                    
                    group.enter()
                    self.saveDBQueue.async {
                        channelsArray = self.parseManager.parseChannel(querySnapshot)
                        group.leave()
                    }
                    
                    group.enter()
                    self.saveDBQueue.async {
                        self.coreDataManager.saveChannels(array: channelsArray, in: self.coreDataStack)
                        group.leave()
                    }
                    
                    group.wait()
//                    let channelsArray = self.parseManager.parseChannel(querySnapshot)
//                    self.coreDataManager.saveChannels(array: channelsArray, in: self.coreDataStack)
                    
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
                    self.coreDataManager.saveMessages(id: channelId, array: messagesArray, in: self.coreDataStack)
//                    self.coreDataManager.saveMessages(array: messagesArray, in: self.coreDataStack)
                    
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
