//
//  StoryDayView.swift
//  ECS-TimeTravellersTeam
//
//  Created by Matteo Altobello on 25/01/23.
//

import SwiftUI

struct PictureDescriptionView: View {
    //questo serve per salvare il testo inserito nel TextField
    @State var textStoryDay: String = ""
    @State var image : UIImage
    @State var temperature : String
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Moment.date, ascending: true)],
        animation: .default)
    private var moments: FetchedResults<Moment>
    
    var body: some View {
        VStack{
            
            Text("Story of the day")
                .font(.largeTitle)
            Text(Date.now.formatted(date: .long, time: .shortened))
            TextEditor(text: $textStoryDay)
            
            Button("Add Story") {
                additem()
            }.buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
    }
    
    private func additem() {
        withAnimation {
            let moment = Moment(context: viewContext)
            moment.desc = textStoryDay
            moment.date = takeMyFormatter().string(from: Date.now)
            let pngImageData  = (image).pngData()
            moment.picture = pngImageData
            moment.temperature = temperature
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
    
}

