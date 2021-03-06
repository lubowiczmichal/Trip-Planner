//
//  TripRepository.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 26/02/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import FirebaseStorage
import SwiftUI

class TripRepository: ObservableObject{
    
    private var db = Firestore.firestore()
    @Published var trips = [Trip]()
    @Published var downloadedImage: UIImage = UIImage(systemName: "multiply.circle")!
    let uploadMetadata = StorageMetadata.init()
    let storage = Storage.storage()
    
    func addItem(trip: Trip) {
        var newtrip = trip
        if(newtrip.dateStart > newtrip.dateEnd){
            newtrip.dateEnd = trip.dateStart
        }
        do {
            let _ = try db.collection("a").addDocument(from: newtrip)
        } catch let error {
            print(error)
        }
    }
    
    func loadData(){
        db.collection("a").addSnapshotListener  { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.trips = querySnapshot.documents.compactMap { document in
                    do{
                        let trip = try document.data(as: Trip.self)
                        return trip
                    }
                    catch{
                        print(error)
                    }
                    return nil
                }
            }
        }
    }
    
    func updateDocument(trip: Trip){
        db.collection("a").document(trip.id!).updateData([
            "activeItemsList": trip.activeItemsList,
            "itemsList": trip.itemsList
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
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
    
    
    func uploadPhoto(image: UIImage, name: String) {
        let uploadRef = Storage.storage().reference(withPath: "user1/\(name).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            return
        }
        uploadMetadata.contentType = "image/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error{
                print("Error \(error)")
            }
            print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
        }
    }
    
    func downloadPhoto(name: String) {
        let downloadRef = storage.reference().child("user1/\(name).jpg")
        downloadRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
                self.downloadPhoto(name: name)
            } else {
                self.downloadedImage = UIImage(data: data!)!
            }
        }
    }
    
    func deletePhoto(name: String){
        let desertRef = Storage.storage().reference(withPath: "user1").child("\(name).jpg")
        desertRef.delete { error in
          if let error = error {
            print(error)
          } else {
            print("done")
          }
        }
    }
    
}
