//
//  ConditionViewModel.swift
//  ECS-TimeTravellersTeam
//
//  Created by Matteo Altobello on 18/01/23.
//

import SwiftUI

@MainActor
class WeatherConditionViewModel: ObservableObject {
    /// Struct to match JSON `Data`
    @Published var weatherCondition: WeatherCondition?
    @Published var statusCode: String = "200"
    @Published var anErrorOccurred: Bool = false
    
    /// Create a urlSession object, use this to perform requests
    let session: URLSession = URLSession(configuration: .default)
    
    ///URLComponent, use this to create and manipulate endpoints
    var urlComponents = URLComponents(string: "https://yahoo-weather5.p.rapidapi.com")
    
    /// Decoder for JSON `Data`
    lazy var decoder = JSONDecoder()
    
    /// Encoder for JSON `Data`
    lazy var encoder = JSONEncoder()
    
    ///This function allows you to be able to create the URLRequest object, which can be used to be able to make a network call
    ///
    /// - Parameters:
    ///   - method: The HTTP Method
    ///   - path: The path of the request
    ///   - apiKey: The Bearer Token useful for authentication of the request if needed.
    ///   - queryItems: The Query items of the request if needed.
    ///   - body: The body of the request if needed.
    ///
    func buildRequest(method: String,
                      path: String,
                      apiKey: String? = nil,
                      apiKeyField: String? = nil,
                      queryItems: [URLQueryItem]? = nil,
                      body: (any Codable)? = nil)
    -> URLRequest? {
        urlComponents?.path = path
        if let queryItems = queryItems {
            urlComponents?.queryItems = queryItems
        }
        guard let theURL = urlComponents?.url else {return nil}
        
        var request = URLRequest(url: theURL)
        request.httpMethod = method
        
        if let apiKey, let apiKeyField {
            request.addValue("\(apiKey)", forHTTPHeaderField: "\(apiKeyField)")
        }
        
        if let body {
            do {
                request.httpBody = try encoder.encode(body) // asData(json: body)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                return nil
            }
        }
        
        return request
    }
    
    func getWeatherConditions(path: String, latitude: Double, longitude: Double) async throws {
        print("Taking weather conditions for latitude(\(latitude)) and longitude(\(longitude))")
        //var latitude = 40.877094
        //var longitude = 14.309775
        //print("Taking weather conditions for latitude(\(latitude)) and longitude(\(longitude))")
        let request = buildRequest(
            method: "GET",
            path: path,
            apiKey: "b9c16c5a91mshd827d0ba27cf3a0p10e8ccjsn78fd6bc5dc79",
            apiKeyField: "x-rapidapi-key",
            queryItems: [
                URLQueryItem(name:"lat", value: "\(latitude)"),
                URLQueryItem(name: "long", value:"\(longitude)"),
                URLQueryItem(name: "u", value: "c")
            ]
        )
        guard let request else {
            throw NetworkError.badRequest
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = "\(httpResponse.statusCode)"
                guard httpResponse.statusCode == 200 else {
                    print("error in get response with status code: \(httpResponse.statusCode)")
                    anErrorOccurred = true
                    return
                }
            }
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let decodedResponse = try? decoder.decode(YMResponse.self, from: data) {
                self.weatherCondition = decodedResponse.currentObservation.condition
            }
            if let weatherCondition = self.weatherCondition {
                print("weather conditions are: \(weatherCondition.temperature!) e \(String(describing: weatherCondition.text))")
            }
        } catch {
            print("hey")
        }
    }
    
    /*func getCondition(latitude: Double, longitude: Double) async {
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
    }*/
    
}
