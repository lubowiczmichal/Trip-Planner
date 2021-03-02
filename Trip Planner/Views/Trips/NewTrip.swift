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
            Button(action: {
                let trip = Trip(name: name, description: description, imageName: "", dateStart: dateStart, dateEnd: dateEnd)
                trip.addItem()
            }) {
                Text("Write")
                    .padding(10)
                    .background(Color.red)
            }
        }
    }
}


struct NewTrip_Previews: PreviewProvider {
    static var previews: some View {
        NewTrip()
    }
}
