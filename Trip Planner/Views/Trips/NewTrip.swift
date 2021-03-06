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
    @State var itemsList: [String] = []
    @State var activeItemsList: [Bool] = []
    @State private var rootWord = ""
    @State private var newItem = ""
    @ObservedObject var upload = NewTripViewModel()
    @ObservedObject var list = TripsListViewModel()
    @StateObject var repo = TripRepository()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingAlert = false
    
    @State private var imageName: String = ""
    
    
    @State private var imageURL: String = ""
    
    @State var keyboardActive:Bool = false
    @State var textFieldActive: Bool = false
    var body: some View {
            ScrollView{
                VStack{
                    Group{
                        if image != nil {
                            image?
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 250)
                        }else{
                            ZStack{
                                Rectangle()
                                    .fill(Color.secondary)
                                    .frame(width: 100, height: 100)
                                Text("Tap to select")
                                    .foregroundColor(.white)
                                    .background(Color.orange)
                            }
                            
                        }
                    }
                    .onTapGesture {
                        self.showingImagePicker = true
                    }
                    .sheet(isPresented: $showingImagePicker, onDismiss: loadImage, content: {
                        ImagePicker(image: self.$inputImage)
                    })
                    HStack{
                        Text("Nazwa")
                        TextField("", text: $name, onEditingChanged: { (editingChanged) in
                            if editingChanged {
                                self.textFieldActive = true
                            } else {
                                self.textFieldActive = false
                            }
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    DatePicker(selection: $dateStart, in:Date()..., displayedComponents: .date, label: { Text("Data wyjazdu") })
                    DatePicker(selection: $dateEnd, in:dateStart..., displayedComponents: .date, label: { Text("Data powrotu") })
                    HStack{
                        Text("Opis")
                            .frame(height: 25)
                            .onAppear {
                                isKeyboardActive()
                            }
                        Spacer()
                        if(keyboardActive && !textFieldActive){
                            Button(action: {
                                self.hideKeyboard()
                            }) {
                                ZStack{
                                    Rectangle()
                                        .background(Color.blue)
                                        .cornerRadius(5)
                                        .frame(width: 90, height: 25)
                                    Text("Zatwierdź")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    TextEditor(text: $description)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    Button(action: {
                        if(name==""){
                            showingAlert = true
                        } else {
                            if imageName == ""{
                                imageName = "wycieczka"
                            }
                            let trip = Trip(name: name, description: description, imageName: imageName, dateStart: dateStart, dateEnd: dateEnd, itemsList: itemsList, activeItemsList: activeItemsList)
                            repo.addItem(trip: trip)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Write")
                            .padding(10)
                            .background(Color.red)
                    }
                    
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Brak nazwy"),
                              message: Text("Wprowadź nazwę"),
                              dismissButton: .default(Text("OK")))
                    }
                    /*
                    Button(action: {
                        let randomID = UUID.init().uuidString
                        upload.uploadPhoto(image: inputImage!, name: randomID)
                        imageName = randomID
                    }) {
                        Text("upload")
                            .padding(10)
                            .background(Color.red)
                    }
     */
                    TextField("Add item", text: $newItem,onEditingChanged: { (editingChanged) in
                        if editingChanged {
                            self.textFieldActive = true
                        } else {
                            self.textFieldActive = false
                        }
                    }, onCommit: addNewItem)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    ForEach(itemsList, id: \.self){ item in
                        HStack{
                            Button(action: {
                                activeItemsList[itemsList.firstIndex(of: item)!].toggle()
                            }) {
                                Image(systemName: activeItemsList[itemsList.firstIndex(of: item)!] ? "circle.fill" : "circle")
                            }
                            Text(item)
                            Spacer()
                        }
                    }
                    Spacer(minLength: 50)
                }
            }
        }
        
        func addNewItem() {
            guard newItem.count > 0 else {
                return
            }

            itemsList.insert(newItem, at: 0)
            activeItemsList.insert(false, at: 0)
            newItem = ""
        }
        
        private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        private func isKeyboardActive(){
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                self.keyboardActive = true
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
                self.keyboardActive = false
            }
        }
        
        private func loadImage(){
            guard let inputImage = inputImage else { return }
            image = Image(uiImage: inputImage)
        }
    }


struct NewTrip_Previews: PreviewProvider {
    static var previews: some View {
        NewTrip()
    }
}
