//
//  CoreDataService.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 20.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataService {
    func getContext() -> NSManagedObjectContext
}

class CoreDataService: ICoreDataService {
    private let coreData: ICoreDataStack
    
    init(coreData: ICoreDataStack) {
        self.coreData = coreData
    }
    
    func getContext() -> NSManagedObjectContext {
        return coreData.mainContext
    }
}
