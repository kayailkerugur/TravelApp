//
//  Formatter.swift
//  TravelApp
//
//  Created by İlker Kaya on 17.01.2023.
//

import Foundation

class Formatter {
    
    func dateFormat(time: String) -> String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        
        let date = dateFormat.date(from: time)
        return dateFormatterPrint.string(from: date!)
    }
    
    func timeFormat(time: String) -> String{
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm"
        
        let time = timeFormat.date(from: time)
        return dateFormatterPrint.string(from: time!)
    }
}

