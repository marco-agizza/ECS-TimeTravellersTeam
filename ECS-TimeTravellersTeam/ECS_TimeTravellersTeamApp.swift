//
//  ECS_TimeTravellersTeamApp.swift
//  ECS-TimeTravellersTeam
//
//  Created by Marco Agizza on 12/01/23.
//

import SwiftUI

@main
struct ECS_TimeTravellersTeamApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
