//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 11.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class OperationDataManager: IDataFileService {
    private let nameFile = "name.txt"
    private let descriptionFile = "description.txt"
    private let photoFile = "photo.png"
    
    func saveData(_ info: ProfileInfo, completion: @escaping () -> Void) {
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
                completion()
            }
            operationQueue.addOperation(operation)
        }
    }
    
    func fetchData(completion: @escaping () -> Void) -> ProfileInfo {
        var profileInfo = ProfileInfo()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let nameFileURL = dir.appendingPathComponent(self.nameFile)
            let descFileURL = dir.appendingPathComponent(self.descriptionFile)
            let photoFileURL = dir.appendingPathComponent(self.photoFile)

            let operationQueue = OperationQueue()
            let operation = LoadOperation()
            operation.nameFileURL = nameFileURL
            operation.descFileURL = descFileURL
            operation.photoFileURL = photoFileURL
            operation.completionBlock = {
                completion()
            }
            operationQueue.addOperations([operation], waitUntilFinished: true)
            profileInfo = operation.profile ?? ProfileInfo()
        }
        return profileInfo
    }
}

class SaveOperation: Operation {
    var profile: ProfileInfo?
    var nameFileURL: URL?
    var descFileURL: URL?
    var photoFileURL: URL?
    
    override func main() {
        do {
            if let name = profile?.name, name != UserProfile.shared.name {
                guard let path = nameFileURL else { return }
                try name.write(to: path, atomically: false, encoding: .utf8)
                UserProfile.shared.name = name
            }
            
            if let desc = profile?.description, desc != UserProfile.shared.description {
                guard let path = descFileURL else { return }
                try desc.write(to: path, atomically: false, encoding: .utf8)
                UserProfile.shared.description = desc
            }
            
            if let photo = profile?.photo, photo != UserProfile.shared.photo {
                if let data = photo.pngData() {
                    guard let path = photoFileURL else { return }
                    try data.write(to: path)
                    UserProfile.shared.photo = photo
                }
            }
        } catch {
            AlertManager.showActionAlert(withMessage: "Не удалось сохранить данные") { _ in
                self.main()
            }
        }
    }
}

class LoadOperation: Operation {
    var profile: ProfileInfo?
    var nameFileURL: URL?
    var descFileURL: URL?
    var photoFileURL: URL?
    
    override func main() {
        var loadProfile = ProfileInfo()
        do {
            guard let namePath = nameFileURL,
                  let descPath = descFileURL,
                  let photoPath = photoFileURL else { return }
            
            loadProfile.name = try String(contentsOf: namePath, encoding: .utf8)
            loadProfile.description = try String(contentsOf: descPath, encoding: .utf8)
            let imageData = try Data(contentsOf: photoPath)
            loadProfile.photo = UIImage(data: imageData)
            
            UserProfile.shared.name = loadProfile.name ?? "Name Surname"
            UserProfile.shared.description = loadProfile.description ?? "You description"
            UserProfile.shared.photo = loadProfile.photo ?? UIImage(named: "clearFile")
            
            self.profile = loadProfile
        } catch {
            loadProfile.name = "Name Surname"
            loadProfile.description = "You description"
            loadProfile.photo = UIImage(named: "clearFile")
            self.profile = loadProfile
        }
    }
}
