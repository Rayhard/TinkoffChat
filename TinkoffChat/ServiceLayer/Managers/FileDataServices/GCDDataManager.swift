//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 11.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

protocol IThemeFileService {
    func saveTheme(_ theme: String)
}

class GCDDataManager: IDataFileService, IThemeFileService {
    private let saveQueue = DispatchQueue(label: "GCDDataManager_Save", qos: .default, attributes: .concurrent)
    private let loadQueue = DispatchQueue(label: "GCDDataManager_Load", qos: .userInitiated, attributes: .concurrent)
    
    let fileCore: IFileManagerCore
    
    init(fileCore: IFileManagerCore) {
        self.fileCore = fileCore
    }
    
    func saveData(_ info: ProfileInfo, completion: @escaping () -> Void) {
        saveQueue.async {
            if let name = info.name, name != UserProfile.shared.name {
                self.fileCore.saveTextFile(file: .nameFile, content: name)
            }
            
            if let desc = info.description, desc != UserProfile.shared.description {
                self.fileCore.saveTextFile(file: .descriptionFile, content: desc)
            }
            
            if let photo = info.photo, photo != UserProfile.shared.photo {
                self.fileCore.saveImageFile(file: .photoFile, content: photo)
            }
            
            completion()
        }
    }
    
    func saveTheme(_ theme: String) {
        saveQueue.async {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let themeFileUrl = dir.appendingPathComponent("currentTheme.txt")
                
                do {
                    try theme.write(to: themeFileUrl, atomically: false, encoding: .utf8)
                } catch {
                    AlertManager.showActionAlert(withMessage: "Не удалось сохранить данные") { _ in
                        self.saveTheme(theme)
                    }
                }
            }
        }
    }
    
    func fetchData(completion: @escaping () -> Void) -> ProfileInfo {
        var profileInfo = ProfileInfo()
        let group = DispatchGroup()
        
        group.enter()
        loadQueue.async {
            profileInfo.name = self.fileCore.getTextFile(file: .nameFile)
            profileInfo.description = self.fileCore.getTextFile(file: .descriptionFile)
            profileInfo.photo = self.fileCore.getImageFile(file: .photoFile)

            group.leave()
        }
        group.wait()
        completion()
        
        return profileInfo
    }
}
