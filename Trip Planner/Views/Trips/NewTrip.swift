//
//  NewTrip.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 24/02/2021.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct NewTrip: View {
    @State var name: String = ""
    @State var dateStart: Date = Date()
    @State var dateEnd: Date = Date()
    @State var description: String = ""
    @ObservedObject var upload = NewTripViewModel()
    @ObservedObject var list = TripsListViewModel()
    
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var imageURL: String = ""
    
    var ref: DocumentReference!
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack{
            HStack{
                Text("Nazwa")
                TextField("", text: $name)
            }
            DatePicker(selection: $dateStart, label: { Text("Data wyjazdu") })
            DatePicker(selection: $dateEnd, label: { Text("Data powrotu") })
            HStack{
                Text("Opis")
                TextField("", text: $description)
                //.dać opis na więcej lini
            }
            ZStack{
                Rectangle()
                    .fill(Color.secondary)
                if image != nil {
                    image?
                        .resizable()
                        .scaledToFit()
                }else{
                    Text("Tap to select")
                        .foregroundColor(.white)
                        .background(Color.orange)
                }
            }
            .onTapGesture {
                self.showingImagePicker = true
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage, content: {
                ImagePicker(image: self.$inputImage)
            })
            Button(action: {
                if imageURL == ""{
                    imageURL = "wycieczka.jpg"
                }
                let trip = Trip(name: name, description: description, imageURL: imageURL, dateStart: dateStart, dateEnd: dateEnd)
                trip.addItem()
            }) {
                Text("Write")
                    .padding(10)
                    .background(Color.red)
            }
            Button(action: {
                let randomID = UUID.init().uuidString
                upload.uploadPhoto(image: inputImage!, name: randomID)
                imageURL = randomID
            }) {
                Text("upload")
                    .padding(10)
                    .background(Color.red)
            }
            Button(action: {
                self.showingImagePicker = true
            }) {
                Text("download")
                    .padding(10)
                    .background(Color.red)
            }
        }
    }
    
    func loadImage(){
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}


struct NewTrip_Previews: PreviewProvider {
    static var previews: some View {
        NewTrip()
    }
}
