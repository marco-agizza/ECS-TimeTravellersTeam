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
    @EnvironmentObject var photosVM: PhotosViewModel
    let decoder = JSONDecoder()
    var urlComponents = URLComponents(string: "https://yahoo-weather5.p.rapidapi.com")!
    
    func getCondition(latitude: Double, longitude: Double) async {
        do {
            urlComponents.path = "/weather"
            urlComponents.queryItems = [
                URLQueryItem(name:"lat", value: "\(latitude)"),
                URLQueryItem(name: "long", value:"\(longitude)"),
                URLQueryItem(name: "u", value: "c")
            ]
            print("urlComponents.queryItems: \(urlComponents.queryItems)")
            let url = urlComponents.url!
            var request = URLRequest(url: url)
            request.addValue("b9c16c5a91mshd827d0ba27cf3a0p10e8ccjsn78fd6bc5dc79", forHTTPHeaderField: "x-rapidapi-key")
            print("ok1")
            let (data, _) = try await URLSession.shared.data(for: request)
            print("ok2")
            self.condition = try decoder.decode(YMResponse.self, from: data).current_observation.condition
            print("ok3")
        } catch {
            print("An error occurs in GET operation")
        }
    }
    
}
