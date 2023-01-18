//
//  StoryDayView.swift
//  ECS-TimeTravellersTeam
//
//  Created by Carmine Cinquegrana on 18/01/23.
//

import SwiftUI

struct StoryDayView: View {
    //questo serve per salvare il testo inserito nel TextField
    @State var textStoryDay: String = ""
    
    var body: some View {
        VStack{
            
            Text("Story of the day")
                .font(.largeTitle)
            Text(Date.now.formatted(date: .long, time: .shortened))
            TextEditor(text: $textStoryDay)
            
            
            
        }
        .padding()
       
    }
}

struct StoryDayView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDayView()
    }
}
