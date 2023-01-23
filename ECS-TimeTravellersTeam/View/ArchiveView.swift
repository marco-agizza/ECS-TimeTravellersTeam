//
//  ArchiveView.swift
//  ECS-TimeTravellersTeam
//
//  Created by Antonio Esposito on 23/01/23.
//

import SwiftUI
import CoreData

struct ArchiveView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        
        NavigationView {
            
            List {
                ForEach(items) { item in
                    NavigationLink {
                        
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                    
                    
                }
              
                .navigationBarTitle("Archive")

                
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.blue)
                     

                }
                }
            }
            Text("Select an item")
        }
    }


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
