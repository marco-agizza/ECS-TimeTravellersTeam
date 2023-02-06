//
//  PictureDescriptionView.swift
//  ECS-TimeTravellersTeam
//
//  Created by Marco Agizza on 05/02/23.
//

import SwiftUI

struct PictureDescriptionButton: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
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
            }
        }
    }
}

struct PictureDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        PictureDescriptionButton()
    }
}
