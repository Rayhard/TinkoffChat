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
    var firebaseParseService: IFirebaseParserService { get }
    var gcdService: IDataFileService { get }
    var operationService: IDataFileService { get }
    var coreDataService: ICoreDataService { get }
}

class ServicesAssembly: IServicesAssembly {
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var firebaseService: IFirebaseService = FirebaseDataManager(parserService: firebaseParseService,
                                                                     coreDataService: coreDataService)
    
    lazy var gcdService: IDataFileService = GCDDataManager()
    lazy var operationService: IDataFileService = OperationDataManager()
    
    lazy var firebaseParseService: IFirebaseParserService = FirebaseParseManager(coreDataService: coreDataService)
    
    lazy var coreDataService: ICoreDataService = CoreDataManager(coreData: coreAssembly.coreDataStack)

}
