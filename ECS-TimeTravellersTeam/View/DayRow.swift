//
//  DayRow.swift
//  ECS-TimeTravellersTeam
//
//  Created by Carmine Cinquegrana on 23/01/23.
//

import SwiftUI

struct DayRow: View {
    var body: some View {
        HStack{
            Image("ProvaDeserto")
                .resizable()
                .frame(width: 50, height: 50)
            Text("DATA FOTO")
            Spacer()
            
        }
    }
}

struct DayRow_Previews: PreviewProvider {
    static var previews: some View {
        DayRow()
    }
}
