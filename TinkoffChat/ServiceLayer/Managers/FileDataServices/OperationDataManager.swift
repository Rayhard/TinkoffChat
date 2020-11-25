//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 11.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

class OperationDataManager: IDataFileService {
    let fileCore: IFileManagerCore
    
    init(fileCore: IFileManagerCore) {
        self.fileCore = fileCore
    }
    
    func saveData(_ info: ProfileInfo, completion: @escaping () -> Void) {
        let operationQueue = OperationQueue()
        let operation = SaveOperation()
        operation.profile = info
        operation.fileCore = fileCore
        operation.completionBlock = {
            completion()
        }
        operationQueue.addOperation(operation)
    }
    
    func fetchData(completion: @escaping () -> Void) -> ProfileInfo {
        var profileInfo = ProfileInfo()
        
        let operationQueue = OperationQueue()
        let operation = LoadOperation()
        operation.fileCore = fileCore
        operation.completionBlock = {
            completion()
        }
        operationQueue.addOperations([operation], waitUntilFinished: true)
        profileInfo = operation.profile ?? ProfileInfo()
        
        return profileInfo
    }
}

class SaveOperation: Operation {
    var profile: ProfileInfo?
    
    var fileCore: IFileManagerCore?
    
    override func main() {
        if let name = profile?.name, name != UserProfile.shared.name {
            fileCore?.saveTextFile(file: .nameFile, content: name)
            UserProfile.shared.name = name
        }
        
        if let desc = profile?.description, desc != UserProfile.shared.description {
            fileCore?.saveTextFile(file: .nameFile, content: desc)
            UserProfile.shared.description = desc
        }
        
        if let photo = profile?.photo, photo != UserProfile.shared.photo {
            if let data = photo.pngData() {
                fileCore?.saveImageFile(file: .photoFile, content: data)
                UserProfile.shared.photo = photo
            }
        }
    }
}

class LoadOperation: Operation {
    var profile: ProfileInfo?
    
    var fileCore: IFileManagerCore?
    
    override func main() {
        var loadProfile = ProfileInfo()
        loadProfile.name = self.fileCore?.getTextFile(file: .nameFile)
        loadProfile.description = self.fileCore?.getTextFile(file: .descriptionFile)
        loadProfile.photo = self.fileCore?.getImageFile(file: .photoFile)
        
        UserProfile.shared.name = loadProfile.name ?? "Name Surname"
        UserProfile.shared.description = loadProfile.description ?? "You description"
        UserProfile.shared.photo = loadProfile.photo ?? UIImage(named: "clearFile")
        
        self.profile = loadProfile
    }
}
