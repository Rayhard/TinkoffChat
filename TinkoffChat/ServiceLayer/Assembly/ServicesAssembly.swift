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
//    var firebaseParseService: IFirebaseParseService { get }
//    var alertService: IAlertService { get }
    var gcdService: IDataFileService { get }
    var operationService: IDataFileService { get }
}

class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var firebaseService: IFirebaseService = FirebaseDataManager()
    lazy var gcdService: IDataFileService = GCDDataManager()
    lazy var operationService: IDataFileService = OperationDataManager()

}
