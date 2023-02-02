//
//  FlightModel.swift
//  TravelApp
//
//  Created by İlker Kaya on 17.01.2023.
//

import Foundation
import SwiftyJSON

struct FlightModel: Codable {
    var departure_airport: String = "noData"
    var arrival_airport: String = "noData"
    var arrival_date: String = "noData"
    var arrival_time: String = "noData"
    var departure_date: String = "noData"
    var departure_time: String = "noData"
    var arrival_iata: String = "noData"
    var departure_iata: String = "noData"
    
    init(json: JSON){
        self.departure_airport = json["deparature"]["airport"].stringValue
        self.arrival_airport = json["arrival"]["airport"].stringValue
        self.arrival_date = Formatter().dateFormat(time: String(json["arrival"]["scheduled"].stringValue.prefix(19)))
        self.arrival_date = Formatter().timeFormat(time: String(json["arrival"]["scheduled"].stringValue.prefix(19)))
        self.departure_date = Formatter().dateFormat(time: String(json["departure"]["scheduled"].stringValue.prefix(19)))
        self.departure_time = Formatter().timeFormat(time: String(json["departure"]["scheduled"].stringValue.prefix(19)))
        self.arrival_iata = json["arrival"]["iata"].stringValue
        self.departure_iata = json["departure"]["iata"].stringValue
    }
}

