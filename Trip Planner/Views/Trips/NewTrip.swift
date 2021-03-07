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
    
    @ObservedObject var repo = TripRepository()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingAlert = false
    
    @State private var imageName: String = ""
    @State private var toPackClicked: Bool = false
    
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
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 250, height: 250)
                                .clipped()

                        }else{
                            ZStack{
                                Rectangle()
                                    .fill(Color.secondary)
                                    .frame(width: 150, height: 100)
                                    .cornerRadius(5)
                                Text("Tap to select photo")
                                    .foregroundColor(.white)
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
                        Text("Name")
                        Spacer()
                        TextField("", text: $name, onEditingChanged: { (editingChanged) in
                            if editingChanged {
                                self.textFieldActive = true
                            } else {
                                self.textFieldActive = false
                            }
                        })
                        .frame(width: UIScreen.main.bounds.width*0.75, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    DatePicker(selection: $dateStart, in:Date()..., displayedComponents: .date, label: { Text("Departure date") })
                    DatePicker(selection: $dateEnd, in:dateStart..., displayedComponents: .date, label: { Text("Return date") })
                    HStack{
                        Text("Description")
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
                                    Text("Confirm")
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
                    if(!toPackClicked){
                        HStack{
                            Text("Packing list")
                                .padding(10)
                            Spacer()
                            Button(action: {
                                toPackClicked.toggle()
                            }, label: {
                                Image(systemName: "plus.circle")
                                    .padding(10)
                            })
                        }
                    }
                    else{
                        HStack{
                            TextField("Add item", text: $newItem,onEditingChanged: { (editingChanged) in
                                if editingChanged {
                                    self.textFieldActive = true
                                } else {
                                    self.textFieldActive = false
                                }
                            }, onCommit: addNewItem)
                                .frame(width: UIScreen.main.bounds.width*0.75, height: 30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            .padding(10)
                            Spacer()
                            Button(action: {
                                toPackClicked.toggle()
                            }, label: {
                                Image(systemName: "xmark.circle")
                                    .padding(10)
                            })
                        }
                    }
                    ForEach(itemsList, id: \.self){ item in
                        HStack{
                            Button(action: {
                                activeItemsList[itemsList.firstIndex(of: item)!].toggle()
                            }) {
                                Image(systemName: activeItemsList[itemsList.firstIndex(of: item)!] ? "circle.fill" : "circle")
                                    .padding(5)
                            }
                            Text(item)
                            Spacer()
                        }
                    }
                    Spacer(minLength: 100)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text("")
                        Button("Save") {
                            self.save()
                        }
                    }
                }
            }
         .alert(isPresented: $showingAlert) {
             Alert(title: Text("No name"),
                   message: Text("Enter a name"),
                   dismissButton: .default(Text("OK")))
        }
    }
        
    func save(){
        if(image != nil){
            let randomID = UUID.init().uuidString
            repo.uploadPhoto(image: inputImage!, name: randomID)
            imageName = randomID
        }else{
            imageName = "wycieczka"
        }
        if(name==""){
            showingAlert = true
        } else {
            let trip = Trip(name: name, description: description, imageName: imageName, dateStart: dateStart, dateEnd: dateEnd, itemsList: itemsList, activeItemsList: activeItemsList)
            repo.addItem(trip: trip)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
        func addNewItem() {
            guard newItem.count > 0 else {
                return
            }
            itemsList.append(newItem)
            activeItemsList.append(false)
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
