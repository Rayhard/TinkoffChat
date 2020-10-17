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
    
    func getChannels(completion: @escaping ([Channel]) -> Void) {
//        reference.getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                guard let channels = querySnapshot else { return }
//                var channelsArray: [Channel] = []
//
//                for document in channels.documents {
//                    let dataFile = document.data()
//                    let channel = Channel(indetifier: document.documentID,
//                                          name: dataFile["name"] as? String ?? "none",
//                                          lastMessage: dataFile["lastMessage"] as? String ?? "",
//                                          lastActivity: self.getDataFromTimestamp(dataFile["lastActivity"]))
//
//                    channelsArray.append(channel)
//                }
//
//                completion(channelsArray)
//            }
//        }
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
        
        messageRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let messages = querySnapshot else { return }
                var messagesArray: [Message] = []
                
                for message in messages.documents {
                    let newMessage = Message(content: message["content"] as? String ?? "none",
                                       created: self.getDataFromTimestamp(message["created"]),
                                       senderId: message["senderId"] as? String ?? "none",
                                       senderName: message["senderName"] as? String ?? "none")
                    
                    messagesArray.append(newMessage)
                }
                completion(messagesArray)
            }
        }
        
    }
    
    func sendMessage() {
        
    }
    
    private func getDataFromTimestamp(_ timestamp: Any?) -> Date {
        let dateTimeStamp: Timestamp = timestamp as? Timestamp ?? Timestamp()
        let date: Date = dateTimeStamp.dateValue()
        return date
    }
}
