//
//  HotelVC.swift
//  TravelApp
//
//  Created by İlker Kaya on 20.01.2023.
//

import UIKit

class HotelVC: UIViewController {
    var hotels: [HotelDataModel] = []
    //var hotelList: [HotelModel] = []
    
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getXIB()
        //getHotel()
        navigationController?.isNavigationBarHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        print("hotel datası \(hotels)")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        backImage.isUserInteractionEnabled = true
        backImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //hotels = HotelNetworkManager.getHotel()
    }
    
//    func getHotel(){
//        hotelList.append(HotelModel(title: "NewYorkCity",date: "26/06/2023",numberItem: "5",leftdate: "6 Days"))
//        hotelList.append(HotelModel(title: "NewYorkCity",date: "26/06/2023",numberItem: "5",leftdate: "6 Days"))
//        hotelList.append(HotelModel(title: "NewYorkCity",date: "26/06/2023",numberItem: "5",leftdate: "6 Days"))
//        hotelList.append(HotelModel(title: "NewYorkCity",date: "26/06/2023",numberItem: "5",leftdate: "6 Days"))
//    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer.view as! UIImageView // 1
        
        self.navigationController?.popViewController(animated: true)
        // Your action
    }

    func getXIB(){
        let nib = UINib(nibName: "HotelCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "hotelcell")
    }
}

extension HotelVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotelcell", for: indexPath) as! HotelCell
//        let data = hotelList[indexPath.row]
//        cell.titleLabel.text = data.title
//        cell.dateLabel.text = data.date
//        cell.leftDate.text = data.leftdate
//        cell.numberofitems.text = data.numberItem
        return cell
    }
    
    
}
