//
//  HotelNetworkManager.swift
//  TravelApp
//
//  Created by İlker Kaya on 18.01.2023.
//

import Foundation
import Alamofire
import CryptoKit


class HotelNetworkManager {
    
    private let baseURL: String = "https://api.test.hotelbeds.com/hotel-content-api/1.0"
    private let api_key: String = "4782c4caff0ca4813bbef375fbcbc48b"
    
    static let shared = HotelNetworkManager()
    
    func fetchItem(onSucces: @escaping ([HotelDataModel]?) -> Void) {
        let baseURL: String = "https://api.test.hotelbeds.com/hotel-content-api/1.0"
        let head: HTTPHeaders = getHeader()
        AF.request(baseURL + "/hotels?destinationCode=ABC&from=1&useSecondaryLanguage=false&fields=name,code,description,countryCode,address,city,images&to=20", method:.get, headers: head).validate().responseDecodable(of: Hotel.self) { response in
            
            
            guard let response = response.value else { return }
            
            onSucces(response.hotels)
        }
    }
    
    
    func calculateXSig() -> String {
        let api_key: String = "4782c4caff0ca4813bbef375fbcbc48b"
        let secret = "02e05682b2"
        let time = Int(NSDate().timeIntervalSince1970)
        let input = api_key + secret + String(time)
        let inputD = Data(input.utf8)
        let hashed = SHA256.hash(data: inputD)
        print(hashed.description.components(separatedBy: ":")[1])
            
        return hashed.description.components(separatedBy: ":")[1]
    }
    
    func getHeader() -> HTTPHeaders {
        let api_key: String = "4782c4caff0ca4813bbef375fbcbc48b"
        return ["Accept":"application/json",  "Accept-Encoding":"gzip", "X-Signature":calculateXSig(), "Api-key": api_key]
    }
}

/*
 func fetchItem(onSucces: @escaping (HotelDataModel?) -> Void) {
     let baseURL: String = "https://api.test.hotelbeds.com/hotel-content-api/1.0"
     let head: HTTPHeaders = getHeader()
     AF.request(baseURL + "/hotels?destinationCode=ABC&from=1&useSecondaryLanguage=false&fields=name,code,description,countryCode,address,city,images&to=20", method:.get, headers: head).validate().responseDecodable(of: Hotel.self) { response in
         var hotels: HotelDataModel = []
         
         guard let response = response.value else { return }
         for res in response.hotels {
             hotels.append(res)
         }
         onSucces(hotels)
     }
 }
 */
