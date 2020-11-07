//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 11.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class GCDDataManager: IDataFileService {
    weak var delegat: IDataFileServiceDelegate?
    
    private let nameFile = "name.txt"
    private let descriptionFile = "description.txt"
    private let photoFile = "photo.png"
    
    private let saveQueue = DispatchQueue(label: "GCDDataManager_Save", qos: .default, attributes: .concurrent)
    private let loadQueue = DispatchQueue(label: "GCDDataManager_Load", qos: .userInitiated, attributes: .concurrent)
    
    func saveData(_ info: ProfileInfo) {
        saveQueue.async {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let nameFileURL = dir.appendingPathComponent(self.nameFile)
                let descFileURL = dir.appendingPathComponent(self.descriptionFile)
                let photoFileURL = dir.appendingPathComponent(self.photoFile)
                
                do {
                    if let name = info.name, name != UserProfile.shared.name {
                        try name.write(to: nameFileURL, atomically: false, encoding: .utf8)
                        UserProfile.shared.name = name
                    }
                    
                    if let desc = info.description, desc != UserProfile.shared.description {
                        try desc.write(to: descFileURL, atomically: false, encoding: .utf8)
                        UserProfile.shared.description = desc
                    }
                    
                    if let photo = info.photo, photo != UserProfile.shared.photo {
                        if let data = photo.pngData() {
                            try data.write(to: photoFileURL)
                            UserProfile.shared.photo = photo
                        }
                    }
                    
                    self.delegat?.saveComplited()
                    
                } catch {
                    AlertManager.showActionAlert(withMessage: "Не удалось сохранить данные") { profile in
                        self.saveData(profile)
                    }
                }
            }
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
    
    func fetchData() -> ProfileInfo {
        var profileInfo = ProfileInfo()
        let group = DispatchGroup()
        
        group.enter()
        loadQueue.async {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let nameFileURL = dir.appendingPathComponent(self.nameFile)
                let descFileURL = dir.appendingPathComponent(self.descriptionFile)
                let photoFileURL = dir.appendingPathComponent(self.photoFile)

                do {
                    profileInfo.name = try String(contentsOf: nameFileURL, encoding: .utf8)
                    profileInfo.description = try String(contentsOf: descFileURL, encoding: .utf8)

                    let imageData = try Data(contentsOf: photoFileURL)
                    profileInfo.photo = UIImage(data: imageData)

                    UserProfile.shared.name = profileInfo.name ?? "Name Surname"
                    UserProfile.shared.description = profileInfo.description ?? "You description"
                    UserProfile.shared.photo = profileInfo.photo ?? UIImage(named: "clearFile")
                } catch {
                    profileInfo.name = "Name Surname"
                    profileInfo.description = "You description"
                    profileInfo.photo = UIImage(named: "clearFile")
                }
            }
            group.leave()
        }
        group.wait()
        self.delegat?.loadComplited()
        
        return profileInfo
    }
}
