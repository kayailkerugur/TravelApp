//
//  HotelModel.swift
//  TravelApp
//
//  Created by İlker Kaya on 20.01.2023.
//

import Foundation

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
