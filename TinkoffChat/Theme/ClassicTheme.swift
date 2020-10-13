//
//  ClassicTheme.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 02.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

final class ClassicTheme: ThemeModel{
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .black
    var navigationBarStyle: UIBarStyle = .default

    var inputMessageBubbleColor: UIColor = UIColor(named: "ClassicInputBubble") ?? UIColor()
    var outputMessageBubbleColor: UIColor = UIColor(named: "ClassicOutputBubble") ?? UIColor()
    
    var inputText: UIColor = .black
    var outputText: UIColor = .black
    var listText: UIColor = UIColor(named: "LabelLight") ?? UIColor()
}
