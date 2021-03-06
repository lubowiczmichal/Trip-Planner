//
//  TripDetails.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 19/02/2021.
//

import SwiftUI

struct TripDetails: View {
    
    @State var trip:Trip
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var repo = TripRepository()
    @State private var showingAlert = false
    @State private var deleted = false
    @State private var rootWord = ""
    @State private var newItem = ""
    @State private var toPackClicked: Bool = false
    var body: some View {
        ScrollView{
            VStack{
                ZStack{
                    Image(uiImage: repo.downloadedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .clipped()
                        .onAppear(){
                            repo.downloadPhoto(name: trip.imageName)
                        }
                    VStack{
                        Spacer()
                        HStack{
                            ZStack{
                                Rectangle()
                                    .fill(Color.white)
                                    .opacity(0.8)
                                    .frame(width: UIScreen.main.bounds.width*0.95, height: 35)
                                    .cornerRadius(15, corners: .topRight)
                                    .cornerRadius(15, corners: .bottomRight)
                                Text(trip.name)
                                    .font(.system(size: 25))
                                    .foregroundColor(Color.red)
                                    .padding(.vertical, 10)
                            }
                            Spacer()
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.9)
                }
                Text(trip.description)
                if(!toPackClicked){
                    HStack{
                        Text("Do spakowania")
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
                        TextField("Add item", text: $newItem, onCommit: addNewItem)
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
                ForEach(trip.itemsList, id: \.self){ item in
                    HStack{
                        Button(action: {
                            trip.activeItemsList[trip.itemsList.firstIndex(of: item)!].toggle()
                        }) {
                            Image(systemName: trip.activeItemsList[trip.itemsList.firstIndex(of: item)!] ? "circle.fill" : "circle")
                                .padding(5)
                        }
                        Text(item)
                            .onLongPressGesture {
                                deleteItem(item: item)
                            }
                        Spacer()
                    }
                }
                Spacer(minLength: 100)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Text("")
                    Button("Remove") {
                        showingAlert = true
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Are you sure you want to delete this?"),
                message: Text("There is no undo"),
                primaryButton: .cancel(Text("Anuluj")),
                secondaryButton: .default(Text("Delete"), action: {
                    repo.deleteDocument(trip: trip)
                    presentationMode.wrappedValue.dismiss()
                }))
        }
        .onDisappear(){
        }
    }
    
    func addNewItem() {
        guard newItem.count > 0 else {
            return
        }
        trip.itemsList.append(newItem)
        trip.activeItemsList.append(false)
        newItem = ""
        repo.updateDocument(trip: trip)
        repo.downloadPhoto(name: trip.imageName)
    }
    
    func deleteItem(item:String){
        trip.activeItemsList.remove(at: trip.itemsList.firstIndex(of: item)!)
        trip.itemsList.remove(at: trip.itemsList.firstIndex(of: item)!)
        repo.updateDocument(trip: trip)
        repo.downloadPhoto(name: trip.imageName)
    }
}

struct TripDetails_Previews: PreviewProvider {
    static var previews: some View {
        TripDetails(trip: Trip(id: "A", name: "Wycieczka", description: "Bardzo fajna wycieczka", imageName: "", dateStart: Date(), dateEnd: Date(), itemsList: ["item1", "item2"], activeItemsList: [true, false]))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
