//
//  ECS_TimeTravellersApp.swift
//  ECS-TimeTravellers
//
//  Created by Marco Agizza on 10/01/23.
//

import SwiftUI

@main
struct ECS_TimeTravellersApp: App {
    let persistenceManager = PersistenceManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceManager.container.viewContext)
                .environmentObject(PhotosViewModel())
                .environmentObject(WeatherConditionViewModel())
                .onAppear {
                    print("ciaone")
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
