//
//  TripRepository.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 26/02/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class TripRepository: ObservableObject{
    
    let db = Firestore.firestore()
    
    @Published var trips = [Trip]()
    
    init(){
        loadData()
    }
    
    func loadData(){
        db.collection("users/user1/trips").addSnapshotListener() { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.trips = querySnapshot.documents.compactMap { document in
                    do{
                        let x = try document.data(as: Trip.self)
                        return x
                    }
                    catch{
                        print(error)
                    }
                    return nil
                }
            }
        }
    }
    
}

