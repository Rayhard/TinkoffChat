//
//  NightTheme.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 02.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

final class NightTheme: ThemeModel {
    var backgroundColor: UIColor = .black
    var textColor: UIColor = .white
    var navigationBarStyle: UIBarStyle = .black

    var inputMessageBubbleColor: UIColor = UIColor(named: "NightInputBubble") ?? UIColor()
    var outputMessageBubbleColor: UIColor = UIColor(named: "NightOutputBubble") ?? UIColor()
    
    var inputText: UIColor = .white
    var outputText: UIColor = .white
    var listText: UIColor = UIColor(named: "NightListText") ?? UIColor()
}
