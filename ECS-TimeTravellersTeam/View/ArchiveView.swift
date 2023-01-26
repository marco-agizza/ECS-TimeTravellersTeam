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
    
    @FetchRequest(entity: Moment.entity(), sortDescriptors: [])
    private var moments: FetchedResults<Moment>
    
    
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(moments) { moment in
                    Text(moment.desc!)
                    let image = UIImage(data: moment.picture!)
                    Image(uiImage: image!)
                    let imageData = fetchData()
                    Image(uiImage: convertDataToImage(imageData: imageData))
                }.onDelete(perform: deleteProducts)
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
            }
            Text("Select an item")
        }
    }
    
    private func deleteProducts(offsets: IndexSet) {
        withAnimation {
            offsets.map { moments[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("An error occured: \(error)")
        }
    }
    
    private func fetchData() -> Data {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Moment")
        var pictureData = Data()
        do {
            let result = try viewContext.fetch(fetchRequest)
            for data in result {
                pictureData.append(data.value(forKey: "storedImage") as! Data)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return pictureData
    }
    
    private func convertDataToImage(imageData: Data) -> UIImage {
            return UIImage(data:imageData)!
        
    }
    
    
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
        
    }
}
