//
//  BookmarkVC.swift
//  TravelApp
//
//  Created by İlker Kaya on 16.01.2023.
//

import UIKit
import CoreData

class BookmarkVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let status = whatisStatues.flight
    
    var flightList: [Flight] = []
    
    var flight: [FlightModel] = []
    
    var hotels: [Hotels] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getXIB()
        //getDataFlight()
        getCoreData()
        getCoreDataHotels()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCoreData()
        //getDataFlight()
        self.tableView.reloadData()
    }
    func getXIB(){
        let nib = UINib(nibName: "BookmarkCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "bookmark")
    }
    
    func getCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Flight> = Flight.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            flightList = results
        } catch  {
            print("Error")
        }
    }
    
    func getCoreDataHotels() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Hotels> = Hotels.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            hotels = results
        } catch  {
            print("Error")
        }
    }


}

extension BookmarkVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightList.count + hotels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmark") as! BookmarkCell
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        let data = flightList[indexPath.row]
        cell.nameLabel.text = data.value(forKey: "arrival_airport")! as? String
        let arrival_date = data.value(forKey: "arrival_date")! as? String
        let departure_time = data.value(forKey: "departure_time")! as? String
        let departure_date = data.value(forKey: "departure_date")! as? String
        cell.descriptionLabel.text = "\(arrival_date!) / \(departure_time!):\(departure_date!)"
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if status == whatisStatues.flight {
            let destinationVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailVC
            let data = flightList[indexPath.row]
            
            destinationVC.flight = flightList
            destinationVC.index = indexPath.row
//            destinationVC.arrival_airport?.text = data.value(forKey: "arrival_airport")! as? String
//            destinationVC.arrival_date?.text = data.value(forKey: "arrival_date")! as? String
//            destinationVC.arrival_iata?.text = data.value(forKey: "arrival_iata")! as? String
//            destinationVC.departure_time?.text = data.value(forKey: "departure_time")! as? String
//            destinationVC.departure_date?.text = data.value(forKey: "departure_date")! as? String
//            destinationVC.departure_iata?.text = data.value(forKey: "departure_iata")! as? String
            
            destinationVC.status = whatisStatues.bookmark
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}
