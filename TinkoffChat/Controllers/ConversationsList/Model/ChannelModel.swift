//
//  ChannelModel.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 16.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

struct Channel {
    let indetifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}
