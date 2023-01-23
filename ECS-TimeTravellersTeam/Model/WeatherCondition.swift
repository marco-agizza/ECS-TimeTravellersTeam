//
//  Condition.swift
//  ECS-TimeTravellersTeam
//
//  Created by Matteo Altobello on 18/01/23.
//

import Foundation

struct WeatherCondition: Decodable {
  var temperature : Int?    = nil
  var text        : String? = nil
  var code        : Int?    = nil
}

struct YMCurrentObservation: Decodable {
    var condition: WeatherCondition
}

struct YMResponse: Decodable {
    var currentObservation: YMCurrentObservation
}
