//
//  FirebaseDataManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 16.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit
import Firebase

protocol IFirebaseService {
    func getChannels(completion: @escaping () -> Void)
    func deleteChannel(channel: Channel_db)
    func createNewChannel(name: String)
    func getMessages(channelId: String, completion: @escaping () -> Void)
    func sendMessage(channelId: String, message: String)
}

class FirebaseService: IFirebaseService {
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    let parserService: IFirebaseParserService
    let coreDataService: ICoreDataService
    
    init(parserService: IFirebaseParserService, coreDataService: ICoreDataService) {
        self.parserService = parserService
        self.coreDataService = coreDataService
    }
    
    func getChannels(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            self.reference.addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(String(describing: error))")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        self.parserService.parseNewChannel(diff: diff)
                    case .modified:
                        self.parserService.parseUpdateChannel(diff: diff)
                    case .removed:
                        self.coreDataService.deleteChannel(channelId: diff.document.documentID)
                    }
                    completion()
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
            "senderName": name,
            "created": time
        ])
    }
    
    func deleteChannel(channel: Channel_db) {
        guard let id = channel.identifier else { return }
        let channelRef = reference.document(id)
        channelRef.delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                self.coreDataService.deleteChannel(channelId: id)
            }
        }
    }
    
    func getMessages(channelId: String, completion: @escaping () -> Void) {
        let messageRef = reference.document(channelId).collection("messages")
        
        DispatchQueue.global().async {
            messageRef.addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(String(describing: error))")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        self.parserService.parseNewMessage(channelId: channelId, diff: diff)
                    case .modified:
                        break
                    case .removed:
                        break
                    }

                    completion()
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
