//
//  ConditionViewModel.swift
//  ECS-TimeTravellersTeam
//
//  Created by Matteo Altobello on 18/01/23.
//

import SwiftUI

@MainActor
class ConditionViewModel: ObservableObject {
    
    @Published var condition: Condition?
    
    let decoder = JSONDecoder()
    var urlComponents = URLComponents(string: "https://yahoo-weather5.p.rapidapi.com")!
    
    func getCondition() async {
        do {
            urlComponents.path = "/weather"
            urlComponents.queryItems = [
                URLQueryItem(name:"lat", value: "40.9076"),
                URLQueryItem(name: "long", value:"14.2928"),
                URLQueryItem(name: "u", value: "c")
            ]
            let url = urlComponents.url
            var request = URLRequest(url: url!)
            request.addValue("b9c16c5a91mshd827d0ba27cf3a0p10e8ccjsn78fd6bc5dc79", forHTTPHeaderField: "x-rapidapi-key")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            self.condition = try decoder.decode(YMResponse.self, from: data).current_observation.condition
        } catch {
            print("VAFANCUL")
        }
    }
    
}
