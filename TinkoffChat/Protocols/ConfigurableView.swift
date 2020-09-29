//
//  ConfigurableView.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.09.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol ConfigurableView {
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
