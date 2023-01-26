//
//  SearchVC.swift
//  TravelApp
//
//  Created by İlker Kaya on 16.01.2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import CryptoKit

enum whatisStatues {
    case hotel
    case flight
    case bookmark
}

class SearchVC: UIViewController {
    
    var flightList: [FlightModel] = []
    var filteredFlight: [FlightModel] = []
    
    var hotels: [HotelDataModel] = []
    var filteredHotels: [HotelDataModel] = []
    
    var status = whatisStatues.hotel
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var hotelImageView: UIImageView!
    
    @IBOutlet weak var flightImageView: UIImageView!
    
    
    @IBOutlet weak var searchText: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flightControl()
        getXIB()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchText.delegate = self
        
        hotelImageView.image = UIImage(named: "hotelsegmentselect")
        flightImageView.image = UIImage(named: "flights2")
        
        controlState()
    }
    
    func flightControl(){
        if status == whatisStatues.flight {
            getFlight()
        } else if status == whatisStatues.hotel {
            getHotel()
        }
    }
    
    @objc func hotelImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        status = whatisStatues.hotel
        controlStatus()
        flightList = []
        self.tableView.reloadData()
    }
    
    @objc func flightImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        status = whatisStatues.flight
        controlStatus()
        flightControl()
    }
    
    func controlStatus() {
        if status == whatisStatues.flight {
            hotelImageView.image = UIImage(named: "hotelsegment")
            flightImageView.image = UIImage(named: "flights3")
        } else if status == whatisStatues.hotel {
            hotelImageView.image = UIImage(named: "hotelsegmentselect")
            flightImageView.image = UIImage(named: "flights2")
        }
    }
    
    func getFlight() {
        let url = Environment.baseURL + Environment.api_key + Environment.limit
        AF.request(url).response { response in
            
            let data : JSON = JSON(response.data!)
            let flightsJS = data["data"].arrayValue
            for flightJS in flightsJS {
                let flight = FlightModel(json: flightJS)
                self.flightList.append(flight)
                print("",self.flightList)
                self.tableView.reloadData()
            }
        }
    }
    
    func getHotel() {
        let baseUrl = "https://api.test.hotelbeds.com"
        let contentUrl = "/hotel-content-api/1.0"
        let head: HTTPHeaders = getHeader()
        let url = baseUrl + contentUrl
        AF.request(url + "/hotels?destinationCode=ABC&from=1&useSecondaryLanguage=false&fields=name,code,description,countryCode,address,city,images&to=20", method:.get, headers: head).validate().responseDecodable(of: Hotel.self) { response in

            
            guard let response = response.value else {print(response); return }
            
            for res in response.hotels {
                self.hotels.append(res)
                self.tableView.reloadData()
            }
            print("666\(self.hotels)")
      
        }
        
    }
    // 4782c4caff0ca4813bbef375fbcbc48b
    // 02e05682b2
    func calculateXSig() -> String {
        let apiKey = "8fc1a187f91287e2cf4da8d06cc83f2a"
        let secret = "8a286ab870"
        let time = Int(NSDate().timeIntervalSince1970)
        let input = apiKey + secret + String(time)
        let inputD = Data(input.utf8)
        let hashed = SHA256.hash(data: inputD)
        print(hashed.description.components(separatedBy: ":")[1])
            
        return hashed.description.components(separatedBy: ":")[1]
    }
    
    func getHeader() -> HTTPHeaders {
        let apiKey = "8fc1a187f91287e2cf4da8d06cc83f2a"
        return ["Accept":"application/json",  "Accept-Encoding":"gzip", "X-Signature":calculateXSig(), "Api-key": apiKey]
    }
    
    func getXIB(){
        let nib = UINib(nibName: "SearchCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "searchCell")
    }
    
    func controlState() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hotelImageTapped(tapGestureRecognizer:)))
        hotelImageView.isUserInteractionEnabled = true
        hotelImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(flightImageTapped(tapGestureRecognizer:)))
        flightImageView.isUserInteractionEnabled = true
        flightImageView.addGestureRecognizer(tapGestureRecognizer2)
    }
}


extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if status == whatisStatues.flight {
            return filteredFlight.count
        } else if status == whatisStatues.hotel {
            return filteredHotels.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if status == whatisStatues.flight {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
            let data = filteredFlight[indexPath.row]
            cell.nameLabel.text = data.arrival_airport
            cell.descriptionLabel.text = "\(data.arrival_date) / \(data.departure_time):\(data.departure_date)"
            return cell
        } else if status == whatisStatues.hotel {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
            let data = filteredHotels[indexPath.row]
            let descriptionText = "\(String(describing: data.address.content!))/\(String(describing: data.address.street!))"
            cell.nameLabel.text = data.name.content
            cell.descriptionLabel.text = descriptionText
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if status == whatisStatues.flight {
            let destinationVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailVC
            let data = filteredFlight[indexPath.row]
            destinationVC.flightList = [data]
            destinationVC.status = whatisStatues.flight
            self.navigationController?.pushViewController(destinationVC, animated: true)
        } else if status == whatisStatues.hotel {
            let destinationVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailVC
            let data = filteredHotels[indexPath.row]
            destinationVC.hotels = [data]
            destinationVC.status = whatisStatues.hotel
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if status == whatisStatues.flight {
            filteredFlight = []
            if searchText.count < 3 {
                filteredFlight = []
                self.tableView.reloadData()
            } else if searchText.count > 2 {
                for flight in flightList {
                    if flight.arrival_airport.uppercased().contains(searchText.uppercased()) {
                        filteredFlight.append(flight)
                    }
                }
                self.tableView.reloadData()
            }
        } else if status == whatisStatues.hotel {
            
            filteredHotels = []
            if searchText.count < 3 {
                filteredHotels = []
                self.tableView.reloadData()
            } else if searchText.count > 2{
                for hotel in hotels {
                    if hotel.name.content.uppercased().contains(searchText.uppercased()) {
                        filteredHotels.append(hotel)
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        
        
        
        
    }
}
