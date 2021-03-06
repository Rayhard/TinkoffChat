//
//  FileManager.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 11.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import UIKit

protocol IFileManagerCore {
    func saveTextFile(file: FileUrls, content: String)
    func saveImageFile(file: FileUrls, content: UIImage)
    func getTextFile(file: FileUrls) -> String
    func getImageFile(file: FileUrls) -> UIImage?
}

enum FileUrls: String {
    case nameFile = "name.txt"
    case descriptionFile = "description.txt"
    case photoFile = "photo.png"
}

class FileManagerCore: IFileManagerCore {
    private func getFileUrl(file: FileUrls) -> URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file.rawValue)
            return fileURL
        }
        return nil
    }
    
    func saveTextFile(file: FileUrls, content: String) {
        do {
            guard let url = self.getFileUrl(file: file) else { return }
            try content.write(to: url, atomically: false, encoding: .utf8)
            
            if file == .nameFile {
                UserProfile.shared.name = content
            } else {
                UserProfile.shared.description = content
            }
            
        } catch {
            print(error)
        }
    }
    
    func saveImageFile(file: FileUrls, content: UIImage) {
        do {
            if let data = content.pngData() {
                guard let url = self.getFileUrl(file: file) else { return }
                try data.write(to: url)
                UserProfile.shared.photo = content
            }
        } catch {
            print(error)
        }
    }
    
    func getTextFile(file: FileUrls) -> String {
        var content = ""
        guard let url = self.getFileUrl(file: file) else { return content }
        do {
            content = try String(contentsOf: url, encoding: .utf8)
            
            if file == .nameFile {
                UserProfile.shared.name = content
            } else {
                UserProfile.shared.description = content
            }
        } catch {
            print(error)
        }
        
        return content
    }
    
    func getImageFile(file: FileUrls) -> UIImage? {
        var content = UIImage(named: "clearFile")
        guard let url = self.getFileUrl(file: file) else { return content }
        do {
            let imageData = try Data(contentsOf: url)
            content = UIImage(data: imageData)
            UserProfile.shared.photo = content
        } catch {
            print(error)
        }
        
        return content
    }
}
