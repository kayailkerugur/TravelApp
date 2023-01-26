//
//  FlightVC.swift
//  TravelApp
//
//  Created by İlker Kaya on 18.01.2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class FlightVC: UIViewController {
    
    var flightList: [FlightModel] = []
    
    let url = URL(string: Environment.baseURL + Environment.api_key + Environment.limit)
    
    var kontrol: Bool = false

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let flightData = FlightNetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getXIB()
        getFlight()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationController?.isNavigationBarHidden = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func getXIB(){
        let nib = UINib(nibName: "FlightCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "flightCell")
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popToRootViewController(animated: true)
        // Your action
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
}

extension FlightVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flightList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // collectionView.dequeueReusableCell(withReuseIdentifier: "flightCell", for: indexPath) as? FlightCell
        //let cell = Bundle.main.loadNibNamed("FlightCell", owner: self,options: nil)?.first as! FlightCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flightCell", for: indexPath) as! FlightCell
        cell.contentView.layer.cornerRadius = 10.0;
        let data = flightList[indexPath.row]
        cell.flightNameLabel.text = "\(data.arrival_airport)"
        cell.flightDescriptionLabel.text = "\(data.arrival_date) / \(data.departure_time):\(data.departure_date)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailVC
        destinationVC.flightList = flightList
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
}
