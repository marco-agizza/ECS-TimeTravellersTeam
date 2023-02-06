//
//  Utils.swift
//  ECS-TimeTravellersTeam
//
//  Created by Marco Agizza on 23/01/23.
//

import Foundation

extension Double {
    func truncate(places : Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

func takeMyFormatter() -> DateFormatter {
    let myFormatter = DateFormatter()
    myFormatter.dateFormat = "dd/MM/y"
    return myFormatter
}
