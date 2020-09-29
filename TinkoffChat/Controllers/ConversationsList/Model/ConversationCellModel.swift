//
//  ConversationCellModel.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

struct ConversationCellModel {
    let name: String
    let message: String
    let date: Date
    let isOnline: Bool
    let hasUnreadMessages: Bool
}
