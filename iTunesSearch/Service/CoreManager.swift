//
//  CoreManager.swift
//  iTunesSearch
//
//  Created by Consultant on 5/6/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import Foundation
import CoreData

class CoreManager {
    // MARK: - Core Data stack
    
    var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "iTunesSearch")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveData(media: Media) {
        guard let entity = NSEntityDescription.entity(forEntityName: "MediaFavorite", in: context) else { return }
        let favorite = MediaFavorite(entity: entity, insertInto: context)
     
        print("saving the coredata")
        
        saveContext()
    }
    
    func fetchData() -> [Media]? {
        
        var media = [Media]()
        let fetch = NSFetchRequest<MediaFavorite>(entityName: "MediaFavorite")
        let departmentSort = NSSortDescriptor(key: "timestamp", ascending: true)
        
        fetch.sortDescriptors = [departmentSort]
        
        do {
            let coreFavorites = try context.fetch(fetch)
            print("we fetched core!")
            
            for core in coreFavorites {
            
            }
            
            return media
            
        } catch {
            print("Issue Fetching Last Location Record: \(error.localizedDescription)")
            return media
        }
    }
    
}
