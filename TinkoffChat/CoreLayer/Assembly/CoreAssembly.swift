//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 06.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var coreDataStack: ICoreDataStack { get }
    var fileManagerCore: IFileManagerCore { get }
    var requestSender: IRequestSender { get }
    
    var firebaseParseService: IFirebaseParser { get }
    var coreDataService: ICoreDataManager { get }
    var userDefaultsCore: IUserDefaultsCore { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var coreDataStack: ICoreDataStack = CoreDataStack()
    lazy var fileManagerCore: IFileManagerCore = FileManagerCore()
    lazy var requestSender: IRequestSender = RequestSender()
    
    lazy var firebaseParseService: IFirebaseParser = FirebaseParser(coreDataService: coreDataService)
    lazy var coreDataService: ICoreDataManager = CoreDataManager(coreData: coreDataStack)
    lazy var userDefaultsCore: IUserDefaultsCore = UserDefaultsCore()
}
