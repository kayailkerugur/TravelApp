//
//  DetailVC.swift
//  TravelApp
//
//  Created by İlker Kaya on 19.01.2023.
//

import UIKit
import CoreData

class DetailVC: UIViewController {
    
    var status = whatisStatues.flight
    
    var flightList: [FlightModel] = []
    
    var hotels: [HotelDataModel] = []
    var coreHotels: [Hotels] = []
    
    var flight: [Flight] = []
    
    var index: Int = 0
    
    var control: Bool = false
    
    var controlHotel: Bool = false
    
    @IBOutlet weak var addDeleteButton: UIButton!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var arrival_airport: UILabel!
    
    @IBOutlet weak var arrival_iata: UILabel!
    
    @IBOutlet weak var departure_iata: UILabel!
    
    @IBOutlet weak var arrival_date: UILabel!
    
    @IBOutlet weak var departure_date: UILabel!
    
    @IBOutlet weak var departure_time: UILabel!
    
    
    @IBOutlet weak var imageP: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCoreData()
        getCoreDataHotels()
        controlStatus()
        textSettings()
        navigationController?.isNavigationBarHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func controlStatus(){
        if status == whatisStatues.hotel {
            arrival_date.isHidden = true
            departure_date.isHidden = true
            departure_time.isHidden = true
            dataControl()
        } else if status == whatisStatues.flight {
            arrival_date.isHidden = false
            departure_date.isHidden = false
            departure_time.isHidden = false
            dataControl()
        }
    }
    
    func textSettings() {
        if status == whatisStatues.flight {
            let data = flightList[0]
            arrival_airport.text = data.arrival_airport
            arrival_iata.text = data.arrival_iata
            departure_iata.text = data.departure_iata
            arrival_date.text = data.arrival_date
            departure_date.text = data.departure_date
            departure_time.text = data.departure_time
        } else if status == whatisStatues.hotel {
            let data = hotels[0]
            let image = data.images![0].path
            let url = URL(string: "http://photos.hotelbeds.com/giata/\(image)")!
            imageP.contentMode = .scaleToFill
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.imageP.image = UIImage(data: imageData)
                        
                    }
                    
                }
            }
            arrival_airport.text = "Hotels"
            arrival_iata.text = data.name.content
            departure_iata.text = data.hotelDescription.content
            
        } else if status == whatisStatues.bookmark {
            let data = flight[index]
            arrival_airport.text = data.arrival_airport
            arrival_iata.text = data.arrival_iata
            departure_iata.text = data.departure_iata
            arrival_date.text = data.arrival_date
            departure_date.text = data.departure_date
            departure_time.text = data.departure_time
        }
    }
    
    func dataControl(){
        
        if status == whatisStatues.flight {
            for f in flight {
                if f.arrival_airport == flightList[0].arrival_airport {
                    self.addDeleteButton.setTitle("Remove Bookmark", for: .normal)
                    control = true
                } else {
                    self.addDeleteButton.setTitle("Add Bookmark", for: .normal)
                    control = false
                }
            }
        } else if status == whatisStatues.hotel {
            for h in coreHotels {
                if h.hotelName == hotels[0].name.content {
                    self.addDeleteButton.setTitle("Remove Bookmark", for: .normal)
                    controlHotel = true
                } else {
                    self.addDeleteButton.setTitle("Add Bookmark", for: .normal)
                    controlHotel = false
                }

            }
        }
        
        
    }
    
    func getCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Flight> = Flight.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            flight = results
            dataControl()
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
            coreHotels = results
            dataControl()
        } catch  {
            print("Error")
        }
    }
    


    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.navigationController?.popViewController(animated: true)
        // Your action
    }
    
    
    @IBAction func addBookmark(_ sender: Any) {
        dataControl()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        if status == whatisStatues.flight {
            if control {
//                let data2 = flight[index]
                let data = flightList[0]
                let flightIndex = flight.firstIndex{ $0.arrival_airport == data.arrival_airport }
                
                
                let data3 = flight[flightIndex!]
                 
                print(flightIndex!)
                
                context.delete(data3)
                flight.remove(at: flightIndex!)
                appDelegate.saveContext()
                do{
                    try context.save()
                    dataControl()
                } catch {
                    print("Flight error deleting data \(error)")
                }
            } else  {
                let data = flightList[0]
                let fight = Flight(context: context)
                fight.setValue(data.arrival_airport, forKey: "arrival_airport")
                fight.setValue(data.arrival_iata, forKey: "arrival_iata")
                fight.setValue(data.departure_iata, forKey: "departure_iata")
                fight.setValue(data.arrival_date, forKey: "arrival_date")
                fight.setValue(data.departure_date, forKey: "departure_date")
                fight.setValue(data.departure_time, forKey: "departure_time")
                control = true
                appDelegate.saveContext()
                do {
                    try context.save()
                    dataControl()
                } catch  {
                    print("fligth  error saving data \(error.localizedDescription)")
                }
            }
        } else if status == whatisStatues.hotel {
            if controlHotel {
                let data = hotels[0]
                let hotelIndex = coreHotels.firstIndex{ $0.hotelName == data.name.content }
                
                let data1 = coreHotels[hotelIndex!]
                print(hotelIndex!)
                
                context.delete(data1)
                coreHotels.remove(at: hotelIndex!)
                
                appDelegate.saveContext()
                do {
                    try context.save()
                    dataControl()
                } catch {
                    print("Hotel error delete data \(error.localizedDescription)")
                }
            } else {
                let data = hotels[0]
                
                let image = data.images![0].path
                let url = URL(string: "http://photos.hotelbeds.com/giata/\(image)")!
                let hotel = Hotels(context: context)
                DispatchQueue.global().async {
                    let imageData = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        let images = UIImage(data: imageData!)
                        hotel.setValue(imageData, forKey: "hotelImage")
                    }
                }
                
                hotel.setValue(data.name.content, forKey: "hotelName")
                hotel.setValue(data.hotelDescription.content, forKey: "descrip")
                
                controlHotel = true
                appDelegate.saveContext()
                do {
                    try context.save()
                    dataControl()
                } catch {
                    print("hotel error saving data \(error.localizedDescription)")
                }
            }
        }
        
       
        
    }
}

