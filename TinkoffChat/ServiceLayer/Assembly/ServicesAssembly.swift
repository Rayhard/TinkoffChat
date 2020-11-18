//
//  ServicesAssembly.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 06.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    var firebaseService: IFirebaseService { get }
    var firebaseParseService: IFirebaseParser { get }
    var gcdService: IDataFileService { get }
    var operationService: IDataFileService { get }
    var coreDataService: ICoreDataService { get }
    var themeSaver: IThemeFileService { get }
    var networkService: INetworkService { get }
    var imageCacheService: IImageCacheService { get }
}

class ServicesAssembly: IServicesAssembly {
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var firebaseService: IFirebaseService = FirebaseService(parserService: firebaseParseService,
                                                                     coreDataService: coreDataService)
    
    lazy var gcdService: IDataFileService = GCDDataManager(fileCore: coreAssembly.fileManagerCore)
    lazy var operationService: IDataFileService = OperationDataManager(fileCore: coreAssembly.fileManagerCore)
    lazy var themeSaver: IThemeFileService = GCDDataManager(fileCore: coreAssembly.fileManagerCore)
    
    lazy var firebaseParseService: IFirebaseParser = FirebaseParser(coreDataService: coreDataService)
    
    lazy var coreDataService: ICoreDataService = CoreDataManager(coreData: coreAssembly.coreDataStack)
    
    lazy var networkService: INetworkService = NetworkService(requestSender: coreAssembly.requestSender)
    lazy var imageCacheService: IImageCacheService = ImageCacheService()

}
