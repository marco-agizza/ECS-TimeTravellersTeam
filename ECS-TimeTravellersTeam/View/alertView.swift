//
//  alertView.swift
//  ECS-TimeTravellersTeam
//
//  Created by Carmine Cinquegrana on 23/01/23.
//

import SwiftUI

struct alertView: View {
    @State private var showingAlert = false
    var body: some View {
        Button("Show Alert") {
                    showingAlert = true
                }
                .alert("Connection error", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
    }
    }


struct alertView_Previews: PreviewProvider {
    static var previews: some View {
        alertView()
    }
}
