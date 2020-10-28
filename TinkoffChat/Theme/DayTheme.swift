//
//  DayTheme.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 02.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

final class DayTheme: ThemeModel {
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .black
    var navigationBarStyle: UIBarStyle = .default

    var inputMessageBubbleColor: UIColor = UIColor(named: "DayInputBubble") ?? UIColor()
    var outputMessageBubbleColor: UIColor = UIColor(named: "DayOutputBubble") ?? UIColor()
    var inputText: UIColor = .black
    var outputText: UIColor = .white
    var listText: UIColor = UIColor(named: "LabelLight") ?? UIColor()
}
