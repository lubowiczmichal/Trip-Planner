//
//  TripRepository.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 26/02/2021.
//

import Foundation
import Firebase

class TripRepository: ObservableObject{
    
    private var db = Firestore.firestore()
    
    @Published var trips = [Trip]()

    init(){
        loadData()
    }
    
    func addItem(trip: Trip) {
        do {
            let _ = try db.collection("a").addDocument(from: trip)
        } catch let error {
            print(error)
        }
    }
    
    func loadData(){
        db.collection("a").addSnapshotListener  { (querySnapshot, error) in
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
    
    func deleteDocument(trip: Trip){
        db.collection("a").document(trip.id!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
}
