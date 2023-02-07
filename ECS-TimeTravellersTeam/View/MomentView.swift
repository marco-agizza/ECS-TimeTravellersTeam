//
//  MomentView.swift
//  ECS-TimeTravellersTeam
//
//  Created by Marco Agizza on 06/02/23.
//

import SwiftUI
import UIKit

struct MomentView: View {
    let momentDescription: String?
    let momentDate: String
    let momentTemperature: String?
    let momentWeatherCondition: String?
    let momentPicture: UIImage
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.indigo)
                .frame(height: 210)
            
            HStack{
                VStack (alignment: .leading){
                    Spacer()
                    HStack{
                        Image(uiImage: momentPicture)
                            .resizable()
                            .frame(alignment: .center)
                            .aspectRatio(contentMode: .fill)
                            .scaledToFill()
                            .frame(width: /*@START_MENU_TOKEN@*/75.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/130.0/*@END_MENU_TOKEN@*/)
                            .cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
                            .cornerRadius(12)
                        Spacer()
                        if let momentDescription = momentDescription {
                            Text("Description: \(momentDescription)")
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Text(momentDate)
                            .font(.caption)
                            .bold()
                        Spacer()
                        if let momentWeatherCondition = momentWeatherCondition {
                            Text(momentWeatherCondition)
                                .font(.caption)
                                .bold()
                        }
                        if let momentTemperature = momentTemperature {
                            Text("\(momentTemperature)°C")
                                .font(.caption)
                                .bold()
                        }
                    }
                }
                .padding(.leading, 25)
                .padding(.vertical, 15)
                Spacer()
            }
            .frame(height: 210)
            .padding(.trailing, 20)
        }
    }
}

struct MomentView_Previews: PreviewProvider {
    static var previews: some View {
        MomentView(momentDescription: "This day i feel very melancholic", momentDate: "06/02/2023", momentTemperature: "8", momentWeatherCondition: "Cloudy", momentPicture: UIImage(named: "LeonardoPic")!)
    }
}
