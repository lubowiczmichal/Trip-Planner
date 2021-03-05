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
    
    func addItem(trip: Trip) {
        do {
            try db.collection("users/user1/trips").document(UUID.init().uuidString).setData(from: trip)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
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
    
    func deleteDocument(trip: Trip){
        db.collection("users/user1/trips").document(trip.id!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
}
