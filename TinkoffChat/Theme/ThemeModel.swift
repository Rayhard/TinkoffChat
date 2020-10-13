//
//  ThemeModel.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 02.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

protocol ThemeModel {
    var backgroundColor: UIColor { get }
    var navigationBarStyle: UIBarStyle { get }
    var textColor: UIColor { get }
    
    var inputMessageBubbleColor: UIColor { get }
    var outputMessageBubbleColor: UIColor { get }
    
    var inputText: UIColor { get }
    var outputText: UIColor { get }
    var listText: UIColor { get }
}
