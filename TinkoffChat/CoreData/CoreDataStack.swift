//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Никита Пережогин on 24.10.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var didUpdateDatease: ((CoreDataStack) -> Void)?
    
    private var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).last else {
            fatalError("document path not found")
        }
        return documentsUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    // MARK: - Init Stack
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName,
                                             withExtension: self.dataModelExtension)
        else {
            fatalError("model not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("managedObjectModel cound not be created")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        DispatchQueue.global(qos: .background).async {
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: self.storeUrl,
                                                   options: nil)
                
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return coordinator
    }()
    
    // MARK: - Context
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // MARK: - Save Context
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent { performSave(in: parent) }
    }
    
    // MARK: - CoreData Observers
    
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChanges(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc private func managedObjectContextObjectsDidChanges(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        didUpdateDatease?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
           inserts.count > 0 {
            print("Добавленно объектов: ", inserts.count)
        }
        
        if let update = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
           update.count > 0 {
            print("Обновлено объектов: ", update.count)
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
           deletes.count > 0 {
            print("Обновлено объектов: ", deletes.count)
        }
    }
    
    // MARK: - CoreData Logs
    
    func printDataBaseStats() {
        mainContext.perform {
            do {
                let count = try self.mainContext.count(for: Channel_db.fetchRequest())
                print("\(count) Чатов")
                
                let countMes = try self.mainContext.count(for: Message_db.fetchRequest())
                print("\(countMes) Сообщений")

            } catch {
                
            }
        }
    }
}
