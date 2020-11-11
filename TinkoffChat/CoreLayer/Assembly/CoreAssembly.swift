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
}

class CoreAssembly: ICoreAssembly {
    var coreDataStack: ICoreDataStack = CoreDataStack()
    var fileManagerCore: IFileManagerCore = FileManagerCore()
}
