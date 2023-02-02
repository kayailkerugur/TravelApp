//
//  BookmarkVC.swift
//  TravelApp
//
//  Created by İlker Kaya on 16.01.2023.
//

import UIKit
import CoreData
import Kingfisher

class BookmarkVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var flightList: [Flight] = []
    
    var hotels: [Hotels] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getXIB()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCoreData()
        getCoreDataHotels()
        print("TEST",flightList.count + hotels.count)
    }
    
    func getXIB(){
        let nib = UINib(nibName: "BookmarkCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "bookmark")
    }
    
    func getCoreData() {
        let privateConcurrencyQueue = DispatchQueue(label: "concurrencyHotels",qos: .userInitiated)
        privateConcurrencyQueue.async {
            DispatchQueue.main.async {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest: NSFetchRequest<Flight> = Flight.fetchRequest()
                do {
                    let results = try context.fetch(fetchRequest)
                    self.flightList = results
                    self.tableView.reloadData()
                } catch  {
                    print("Error")
                }
            }
        }
    }
    
    func getCoreDataHotels() {
        let privateConcurrencyQueue = DispatchQueue(label: "concurrencyHotels",qos: .userInitiated)
        privateConcurrencyQueue.async {
            DispatchQueue.main.async {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest: NSFetchRequest<Hotels> = Hotels.fetchRequest()
                do {
                    let results = try context.fetch(fetchRequest)
                    self.hotels = results
                    self.tableView.reloadData()
                } catch  {
                    print("Error")
                }
            }
        }
        
    }
    
    func deleteEntityFlight(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Flight")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
            self.tableView.reloadData()
        } catch let error as NSError {
            // TODO: handle the error
            print("delete flight error \(error)")
        }
    }
    
    func deleteEntityHotel() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Hotels")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            self.tableView.reloadData()
        } catch let error as NSError {
            // TODO: handle the error
            print("delete hotel error \(error)")
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
        
        if hotels.count > 0 && flightList.count > 0 {
            //let hotelCell = tableView.dequeueReusableCell(withIdentifier: "bookmark", for: indexPath) as! BookmarkCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookmark", for: indexPath) as! BookmarkCell
            
            if (indexPath.row < flightList.count)   {
                
                // Flights cell content
                let data = flightList[indexPath.row]
                if let name = data.value(forKey: "arrival_airport") as? String{
                    cell.nameLabel.text = name
                }
                if let arrival_date = data.value(forKey: "arrival_date")! as? String, let departure_time = data.value(forKey: "departure_time")! as? String,let departure_date = data.value(forKey: "departure_date")! as? String {
                    cell.descriptionLabel.text = "\(arrival_date) / \(departure_time):\(departure_date)"
                }
            } else {
                // Hotels cell content
                
                let hotelData = hotels[indexPath.row - flightList.count]
                if let image = (hotelData.hotelImg){
                    cell.backImge.image = UIImage(data: image)
                }
                if let name = hotelData.value(forKey: "hotelName") as? String{
                    cell.nameLabel.text = name
                }
                if let desc = hotelData.value(forKey: "descrip") as? String {
                    cell.descriptionLabel.text = desc
                }
            }
            return cell
        } else if hotels.isEmpty && !flightList.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookmark", for: indexPath) as! BookmarkCell
            
            // Flights cell content
            let data = flightList[indexPath.row]
            cell.nameLabel.text = data.value(forKey: "arrival_airport")! as? String
            let arrival_date = data.value(forKey: "arrival_date")! as? String
            let departure_time = data.value(forKey: "departure_time")! as? String
            let departure_date = data.value(forKey: "departure_date")! as? String
            cell.descriptionLabel.text = "\(arrival_date!) / \(departure_time!):\(departure_date!)"
            
            return cell
        } else if !hotels.isEmpty && flightList.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookmark", for: indexPath) as! BookmarkCell
            // Hotels cell content
            let data = hotels[indexPath.row]
            
            cell.nameLabel.text = data.value(forKey: "hotelName")! as? String
            cell.descriptionLabel.text = data.value(forKey: "descrip") as? String
            if let image = (data.hotelImg){
                cell.backImge.image = UIImage(data: image)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if hotels.count > 0 && flightList.count > 0  {
            if (indexPath.row < flightList.count) {
                let destination = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailVC
                
                destination.flight = flightList
                destination.index = indexPath.row
                destination.status = whatisStatues.bookmark
                self.navigationController?.pushViewController(destination, animated: true)
            } else {
                let destination = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailVC
                destination.coreHotels = hotels
                destination.index = (indexPath.row - flightList.count)
                destination.status = whatisStatues.bookmarkHotel 
                self.navigationController?.pushViewController(destination, animated: true)
            }
        } else if !hotels.isEmpty && flightList.isEmpty {
            let destination = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailVC
            destination.coreHotels = hotels
            destination.index = (indexPath.row - flightList.count)
            destination.status = whatisStatues.bookmarkHotel
            self.navigationController?.pushViewController(destination, animated: true)
        } else if hotels.isEmpty && !flightList.isEmpty {
            let destination = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailVC
            
            destination.flight = flightList
            destination.index = indexPath.row
            destination.status = whatisStatues.bookmark
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
}
