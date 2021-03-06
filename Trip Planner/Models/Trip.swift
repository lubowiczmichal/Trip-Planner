//
//  Trip.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 19/02/2021.
//

import Foundation
import SwiftUI
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Trip: Hashable, Codable, Identifiable {

    @DocumentID var id: String?
    var name: String
    var description: String
    
    var imageName: String
       
    var dateStart: Date
    var dateEnd: Date
    
    var dateStartString: String{
        dateStart.toString()
    }
    var dateEndString: String{
        dateEnd.toString()
    }
    
    var itemsList: [String]
    var activeItemsList: [Bool]
    
    var durration: Int{
        Calendar.current.dateComponents([.day], from: dateStart, to: dateEnd).day ?? 0
    }
    var daysToStart: Int{
        Calendar.current.dateComponents([.day], from: Date(), to: dateStart).day ?? 0
    }
     
}

extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "dd-MM-yyyy"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}
extension Date{
    func toString()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }
}
