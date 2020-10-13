//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 11.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class OperationDataManager: DataManagerProtocol{
    weak var delegat: DataManagerDelegate?
    
    private let nameFile = "name.txt"
    private let descriptionFile = "description.txt"
    private let photoFile = "photo.png"
    
    func saveData(_ info: ProfileInfo){
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let nameFileURL = dir.appendingPathComponent(self.nameFile)
            let descFileURL = dir.appendingPathComponent(self.descriptionFile)
            let photoFileURL = dir.appendingPathComponent(self.photoFile)
            
            let operationQueue = OperationQueue()
            let operation = SaveOperation()
            operation.profile = info
            operation.nameFileURL = nameFileURL
            operation.descFileURL = descFileURL
            operation.photoFileURL = photoFileURL
            operation.completionBlock = {
                self.delegat?.complited()
            }
            operationQueue.addOperation(operation)
        }
        
    }
    
    
    func fetchData() -> ProfileInfo{
        var profileInfo = ProfileInfo()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let nameFileURL = dir.appendingPathComponent(self.nameFile)
            let descFileURL = dir.appendingPathComponent(self.descriptionFile)
            let photoFileURL = dir.appendingPathComponent(self.photoFile)

            let operationQueue = OperationQueue()
            let operation = SaveOperation()
            operation.nameFileURL = nameFileURL
            operation.descFileURL = descFileURL
            operation.photoFileURL = photoFileURL
            operation.completionBlock = {
                self.delegat?.complited()
            }
            operationQueue.addOperation(operation)
            profileInfo = operation.profile ?? ProfileInfo()
        }
        return profileInfo
    }
}


class SaveOperation: Operation{
    var profile: ProfileInfo?
    var nameFileURL: URL?
    var descFileURL: URL?
    var photoFileURL: URL?
    
    override func main() {
        do{
            if let name = profile?.name{
                guard let path = nameFileURL else { return }
                try name.write(to: path, atomically: false, encoding: .utf8)
            }
            
            if let desc = profile?.description{
                guard let path = descFileURL else { return }
                try desc.write(to: path, atomically: false, encoding: .utf8)
            }
            
            if let photo = profile?.photo{
                if let data = photo.pngData() {
                    guard let path = photoFileURL else { return }
                    try data.write(to: path)
                }
            }
            
            AlertManager.showStaticAlert(withMessage: "Данные сохранены")
        } catch {
            AlertManager.showActionAlert(withMessage: "Не удалось сохранить данные") { profile in
                self.main()
            }
        }
    }
}

class LoadOperation: Operation{
    var profile: ProfileInfo?
    var nameFileURL: URL?
    var descFileURL: URL?
    var photoFileURL: URL?
    
    override func main() {
        var profile = ProfileInfo()
        do {
            guard let namePath = nameFileURL,
                  let descPath = descFileURL,
                  let photoPath = photoFileURL else { return }
            profile.name = try String(contentsOf: namePath, encoding: .utf8)
            profile.description = try String(contentsOf: descPath, encoding: .utf8)
            
            let imageData = try Data(contentsOf: photoPath)
            profile.photo = UIImage(data: imageData)
        } catch {
            AlertManager.showStaticAlert(withMessage: "Ошибка загрузки")
        }
    }
    
}
