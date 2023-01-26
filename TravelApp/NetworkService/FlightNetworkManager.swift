//
//  FlightNetworkManager{.swift
//  TravelApp
//
//  Created by İlker Kaya on 17.01.2023.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class FlightNetworkManager {
    static func download(url: URL, collectionView: UICollectionView) -> [FlightModel] {
        var flightList: [FlightModel] = []
        AF.request(url).response { response in
            
            let data : JSON = JSON(response.data!)
            let flightsJS = data["data"].arrayValue
            for flightJS in flightsJS {
                let flight = FlightModel(json: flightJS)
                flightList.append(flight)
                print("",flightList)
            }
            
        }
        collectionView.reloadData()
        return flightList
    }
    
    
}
