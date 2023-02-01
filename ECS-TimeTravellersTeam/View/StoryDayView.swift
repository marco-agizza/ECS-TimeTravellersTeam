//
//  StoryDayView.swift
//  ECS-TimeTravellersTeam
//
//  Created by Carmine Cinquegrana on 01/02/23.
//

import SwiftUI

struct StoryDayView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Rectangle()
                    .frame(width: geometry.size.width * 0.92, height: geometry.size.height * 0.25)
                    .foregroundColor(.white)
                    .cornerRadius(12.0)
                    .padding()
                    .overlay(
                        HStack{
                            Image(systemName: "note.text.badge.plus")
                                .padding(.leading, 18)
                                .padding(.trailing, 18)
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
                            .padding()
                    )
                    .onTapGesture {
                        print("story of the day")
                    }
            }
        }
    }
}

struct StoryDayView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDayView()
    }
}
