//
//  Persistence.swift
//  ECS-TimeTravellersTeam
//
//  Created by Marco Agizza on 12/01/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    init() {
        container = NSPersistentContainer(name: "ECS_TimeTravellersTeam")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Container load failed: \(error)")
            }
        }
    }
}
