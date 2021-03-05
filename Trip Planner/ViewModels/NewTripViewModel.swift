//
//  NewTripViewModel.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 02/03/2021.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI

class NewTripViewModel: ObservableObject{
    
    @Published var downloadedImage: UIImage = UIImage(systemName: "multiply.circle")!
    
    func uploadPhoto(image: UIImage, name: String) {
        let uploadRef = Storage.storage().reference(withPath: "user1/\(name).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            return
        }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error{
                print("Error \(error)")
            }
            print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
        }
    }
    
    func downloadPhoto(name: String) -> Image{
        let downloadRef = Storage.storage().reference().child("user1/\(name).jpg")
        downloadRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
          if let error = error {
            print(error)
          } else {
            self.downloadedImage = UIImage(data: data!)!
          }
        }
        return Image(uiImage: self.downloadedImage)
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
