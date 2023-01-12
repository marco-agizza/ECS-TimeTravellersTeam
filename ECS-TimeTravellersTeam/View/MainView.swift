//
//  MainView.swift
//  ECS-TimeTravellers
//
//  Created by Marco Agizza on 10/01/23.
//
 
import SwiftUI
import CoreData
 
struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
 
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
 
    var body: some View {
        NavigationView {
 
 
 
                VStack {
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 395, height: 550, alignment: .center)
                            .cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
                            .overlay(
                                Image(systemName: "plus")
                                    .resizable(resizingMode: .stretch)
                                    .foregroundColor(.black)
                                    .frame(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                                    .font(.largeTitle)
                                                        .padding())
                            .onTapGesture {
                                                    // Perform action on tap
                                print("Tapped")                                                }
 
 
                    }
 
 
                    Rectangle()
                        .frame(width: 385.0, height: 60)
                        .foregroundColor(.white)
                        .offset(x: 0, y: 0)
                        .cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
                        .overlay(
                            HStack{
                                Image(systemName: "note.text.badge.plus")
                                VStack{
                                    Text("Story of the day")
                                        .font(.bold(.title3)())
                                    Text("Description...").font(.subheadline)
                                        .padding(.trailing, 49)
 
 
 
                                }
 
                                Spacer()
 
 
                            }
                                                    .foregroundColor(.black)
                                                    .font(.title)
                                                    .padding())
                        .onTapGesture {
                            // Perform action on tap
                            print("Tapped")
 
                        }
 
                    Spacer()
 
                }
 
                .navigationBarTitle("Goodmorning")
 
                .navigationBarItems(trailing:
                                        Button(action: {
                    // Perform button action
                }, label: {
                    Image(systemName: "calendar.circle")
                        .foregroundColor(Color.white)
                        .font(.title)
                }))
                .cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
 
 
 
 
 
 
 
 
        }
 
 
 
    }
 
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
 
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
 
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
 
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
 
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
 
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
