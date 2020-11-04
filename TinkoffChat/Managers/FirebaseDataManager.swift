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
    
    func getChannels(completion: @escaping () -> Void) {
        self.reference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(String(describing: error))")
                return
            }
            snapshot.documentChanges.forEach { diff in
                switch diff.type {
                case .added:
                    self.parseManager.parseNewChannel(diff: diff)
                case .modified:
                    self.parseManager.parseUpdateChannel(diff: diff)
                case .removed:
                    self.coreDataManager.deleteChannel(channelId: diff.document.documentID)
                }
                completion()
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
                self.coreDataManager.deleteChannel(channelId: id)
            }
        }
    }
    
    func getMessages(channelId: String, completion: @escaping () -> Void) {
        let messageRef = reference.document(channelId).collection("messages")
        
        messageRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(String(describing: error))")
                return
            }
            snapshot.documentChanges.forEach { diff in
                switch diff.type {
                case .added:
                    self.parseManager.parseNewMessage(channelId: channelId, diff: diff)
                case .modified:
                    break
                case .removed:
                    break
                }

                completion()
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
