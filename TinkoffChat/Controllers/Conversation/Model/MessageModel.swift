//
//  MessageModel.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 16.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

struct Message {
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}
