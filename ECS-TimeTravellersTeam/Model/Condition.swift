//
//  Condition.swift
//  ECS-TimeTravellersTeam
//
//  Created by Matteo Altobello on 18/01/23.
//

import Foundation

struct Condition: Decodable {

  var temperature : Int?    = nil
  var text        : String? = nil
  var code        : Int?    = nil


}

struct YMCurrentObservation: Decodable {
    var condition: Condition
}

struct YMResponse: Decodable {
    var current_observation: YMCurrentObservation
}
