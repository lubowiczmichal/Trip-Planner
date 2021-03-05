//
//  TripDetails.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 19/02/2021.
//

import SwiftUI

struct TripDetails: View {
    
    var trip:Trip
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var upload = NewTripViewModel()
    @ObservedObject var tripsData = TripRepository()
    @State private var showingAlert = false
    @State private var deleted = false
    var body: some View {
        VStack{
            ZStack{
                upload.downloadPhoto(name: trip.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    .clipped()
                VStack{
                    Spacer()
                    HStack{
                        ZStack{
                            Rectangle()
                                .fill(Color.white)
                                .opacity(0.75)
                                .frame(width: UIScreen.main.bounds.width*0.95, height: 35)
                                .cornerRadius(15, corners: .topRight)
                                .cornerRadius(15, corners: .bottomRight)

                            Text(trip.name)
                                .font(.system(size: 25))
                                .foregroundColor(Color.red)
                                .padding(10)
                        }
                        Spacer()
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
            }
            ScrollView{
                Text(trip.description)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button("Tap to show alert") {
                    showingAlert = true
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Are you sure you want to delete this?"),
                message: Text("There is no undo"),
                primaryButton: .cancel(Text("Anuluj")),
                secondaryButton: .default(Text("Delete"), action: {
                    tripsData.deleteDocument(trip: trip)
                    presentationMode.wrappedValue.dismiss()
                }))
        }
    }
}

struct TripDetails_Previews: PreviewProvider {
    static var previews: some View {
        TripDetails(trip: TripRepository().trips[0])
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
