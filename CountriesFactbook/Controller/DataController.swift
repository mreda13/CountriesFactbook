//
//  DataController.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2019-06-16.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentController:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentController.viewContext
    }
    
    let backgroundContext:NSManagedObjectContext!
    
    init(modeName:String){
        persistentController = NSPersistentContainer(name: modeName)
        backgroundContext = persistentController.newBackgroundContext()
    }
    
    func configureContexts(){
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (()->Void)? = nil){
        persistentController.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            self.configureContexts()
            completion?()
        }
    }
    
    static let shared = DataController(modeName: "CountriesFactbook")
    
}
