//
//  HotelModel.swift
//  TravelApp
//
//  Created by İlker Kaya on 20.01.2023.
//

import Foundation

//struct Hotel: Codable {
//    let hotels: [Hotels]?
//}
//
//struct Hotels: Codable {
//    let code: Int
//    let name: Name?
//    let description: Description?
//    let countryCode: String
//    let address: Address?
//    let city: City?
//    let images: [Images]?
//}
//
//struct Name: Codable {
//    let content: String
//}
//
//struct Description: Codable {
//    let content: String
//}
//
//struct Address: Codable {
//    let content: String
//    let street: String
//    let number: String
//}
//
//struct City: Codable {
//    let content: String
//}
//
//struct Images: Codable {
//    let imageTypeCode: String
//    let path: String
//}

//struct Hotel: Codable {
//    let from, to: Int
//    let hotels: [HotelDataModel]?
//}
//
//struct HotelDataModel: Codable {
//    let code: Int?
//    let name, description: City
//    let countryCode: String?
//    let address: Address
//    let city: City
//    let images: [Image]?
//}
//
//struct Address: Codable {
//    let content, street, number: String?
//}
//
//// MARK: - City
//struct City: Codable {
//    let content: String
//}
//
//// MARK: - Image
//struct Image: Codable {
//    let imageTypeCode, path: String
//    let order: Int?
//    let roomCode, roomType, characteristicCode: String?
//}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let empty = try? JSONDecoder().decode(Empty.self, from: jsonData)

struct Hotel: Codable {
    let from, to: Int
    let hotels: [HotelDataModel]
}

// MARK: - Hotel
struct HotelDataModel: Codable {
    let code: Int
    let name, hotelDescription: City
    let countryCode: String
    let address: Address
    let city: City
    let images: [Image]?

    enum CodingKeys: String, CodingKey {
        case code, name
        case hotelDescription = "description"
        case countryCode, address, city, images
    }
}

// MARK: - Address
struct Address: Codable {
    let content, street, number: String?
}

// MARK: - City
struct City: Codable {
    let content: String
}

// MARK: - Image
struct Image: Codable {
    let imageTypeCode, path: String
    let order, visualOrder: Int
    let roomCode, roomType: String?
    let characteristicCode: String?
}
