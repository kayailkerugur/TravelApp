//
//  FlightHotelViewModel.swift
//  TravelApp
//
//  Created by İlker Kaya on 25.01.2023.
//

import Foundation

class FlightHotelViewModel: ObservableObject {
    
    private var hotels: HotelDataModel? {
        didSet {
            guard let h = hotels else { return }
            self.setupText(with: h)
            self.didFinishFetch?()
        }
    }
    
    init(service: HotelNetworkManager) {
        self.service = service
    }
    
    var hotelName: String?
    var desc: String?
    var photoUrl: String?
    
    var didFinishFetch: (() -> ())?
    
    var hotel: [HotelDataModel] = []
    
    private var service: HotelNetworkManager
    
    func fetchHotels(){
        service.fetchItem {  data in
            self.hotel = data!
            
            
        }
    }
    
    private func setupText(with hot: HotelDataModel) {
        self.hotelName = hot.name.content
        self.desc = hot.address.content
        self.photoUrl = hot.images![0].path
        
    }
    
}
