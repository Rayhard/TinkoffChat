//
//  FileManagerMock.swift
//  TinkoffChatTests
//
//  Created by Никита Пережогин on 30.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

@testable import TinkoffChat
import UIKit

final class FileManagerMock: IFileManagerCore {
    var saveCallsCount = 0
    var readCallsCount = 0
    
    func saveTextFile(file: FileUrls, content: String) {
        saveCallsCount += 1
    }
    
    func saveImageFile(file: FileUrls, content: UIImage) {
        saveCallsCount += 1
    }
    
    func getTextFile(file: FileUrls) -> String {
        readCallsCount += 1
        
        return "Some text"
    }
    
    func getImageFile(file: FileUrls) -> UIImage? {
        readCallsCount += 1
        
        return nil
    }
}
