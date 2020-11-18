//
//  ThemesModel.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 11.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol IThemesControllerModel {
    func saveTheme(name: String)
}

protocol ThemesPickerDelegate: class {
    func setTheme(_ theme: ThemeModel)
}

class ThemesControllerModel: IThemesControllerModel {
    let saveService: IThemeFileService
    
    init(saveService: IThemeFileService) {
        self.saveService = saveService
    }
    
    func saveTheme(name: String) {
        saveService.saveTheme(name)
    }
}
