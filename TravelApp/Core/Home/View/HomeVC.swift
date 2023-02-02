//
//  HomeVC.swift
//  TravelApp
//
//  Created by İlker Kaya on 16.01.2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var hotelImage: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let descriptionList = ["Beatiful Alley Scene in Old Town in Europe at Sunset","The Ultimate Guide to Shopping for Travel"]
    let categoryList = ["EXPERIENCE","SHOPPING"]
    let imageList = ["homeImage2","homeImage1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getXIB()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(hotelImageTapped(tapGestureRecognizer:)))
        hotelImage.isUserInteractionEnabled = true
        hotelImage.addGestureRecognizer(tapGestureRecognizer2)
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer.view as! UIImageView // 1
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "flightVC") as! FlightHotelVC
        destinationVC.status = whatisStatues.flight
        self.navigationController?.pushViewController(destinationVC, animated: true) // 3
        // Your action
    }
    
    @objc func hotelImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer.view as! UIImageView // 1
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "flightVC") as! FlightHotelVC
        destinationVC.status = whatisStatues.hotel
        self.navigationController?.pushViewController(destinationVC, animated: true) // 3
        // Your action
    }
    
    func getXIB(){
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "homecell")
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return descriptionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecell", for: indexPath) as! HomeCell
        cell.descriptionLabel.text = descriptionList[indexPath.row]
        cell.categoryLabel.text = categoryList[indexPath.row]
        cell.image.image = UIImage(named: imageList[indexPath.row])
        return cell
    }
}
