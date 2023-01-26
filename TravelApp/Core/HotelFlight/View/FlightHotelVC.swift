//
//  DenemeVC.swift
//  TravelApp
//
//  Created by İlker Kaya on 23.01.2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import CryptoKit
import Kingfisher

class FlightHotelVC: UIViewController {
    
    let viewModel = FlightHotelViewModel(service: HotelNetworkManager())
    
    var status = whatisStatues.flight
    
    var flightList: [FlightModel] = []
    var hotels: [HotelDataModel] = []
    
    let flightUrl = URL(string: Environment.baseURL + Environment.api_key + Environment.limit)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        controlTitle()
        controlData()
        getXIBFlights()
        getXIBHotels()
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationController?.isNavigationBarHidden = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popToRootViewController(animated: true)
        // Your action
    }
    
    func fetchHotels(){
        viewModel.fetchHotels()
        
        viewModel.didFinishFetch = {
            self.hotels = self.viewModel.hotel
        }
            
            
            
    }
    
    func controlTitle(){
        if status == whatisStatues.hotel {
            titleLabel.text = "Hotels"
        } else if status == whatisStatues.flight {
            titleLabel.text = "Flights"
        } else {
            titleLabel.text = ""
        }
    }
    
    func controlData(){
        if status == whatisStatues.flight {
            getFlight()
            self.collectionView.reloadData()
        } else if status == whatisStatues.hotel {
            getHotel()
            //fetchHotels()
            self.collectionView.reloadData()
        }
    }
    
    func getXIBFlights(){
        let nib = UINib(nibName: "FlightCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "flightCell")
    }
    
    func getXIBHotels(){
        let nib = UINib(nibName: "HotelCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "hotelcell")
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
                self.collectionView.reloadData()
            }
        }
    }
    //&to=20
    func getHotel() {
        let baseUrl = "https://api.test.hotelbeds.com"
        let contentUrl = "/hotel-content-api/1.0"
        let head: HTTPHeaders = getHeader()
        let url = baseUrl + contentUrl
        AF.request(url + "/hotels?destinationCode=ABC&from=1&useSecondaryLanguage=false&fields=name,code,description,countryCode,address,city,images", method:.get, headers: head).validate().responseDecodable(of: Hotel.self) { response in


            guard let response = response.value else {print(response); return }

            for res in response.hotels {
                self.hotels.append(res)
                self.collectionView.reloadData()
            }
            print("666\(self.hotels)")

        }

    }
    // 8fc1a187f91287e2cf4da8d06cc83f2a
    // 8a286ab870
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

}

extension FlightHotelVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if status == whatisStatues.flight {
            return flightList.count
        } else if status == whatisStatues.hotel {
            return hotels.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if status == whatisStatues.flight {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flightCell", for: indexPath) as! FlightCell
            cell.contentView.layer.cornerRadius = 10.0;
            let data = flightList[indexPath.row]
            cell.flightNameLabel.text = "\(data.arrival_airport)"
            cell.flightDescriptionLabel.text = "\(data.arrival_date) / \(data.departure_time):\(data.departure_date)"
            return cell
        } else if status == whatisStatues.hotel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotelcell", for: indexPath) as! HotelCell
            let data = hotels[indexPath.row]
            
            
            let descriptionText = "\(String(describing: data.address.content!))/\(String(describing: data.address.street!))"
            let image = data.images?[0].path
            let url = URL(string: "http://photos.hotelbeds.com/giata/bigger/\(image ?? "")")
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    cell.hotelImage.kf.setImage(with: url)
                    
                }  
            }
            
            cell.hotelImage.contentMode = .scaleToFill
            
            cell.titleLabel.text = data.name.content
            cell.descriptionLabel.text = descriptionText
            
            cell.hotelImage.contentMode = .bottom
            
            
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if status == whatisStatues.flight {
            let destinationVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailVC
            let data = flightList[indexPath.row]
            destinationVC.flightList = [data]
            destinationVC.status = whatisStatues.flight
            self.navigationController?.pushViewController(destinationVC, animated: true)
        } else if status == whatisStatues.hotel {
            let destinationVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailVC
            let data = hotels[indexPath.row]
            destinationVC.hotels = [data]
            
            destinationVC.status = whatisStatues.hotel
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
 
    }
    
    
}
