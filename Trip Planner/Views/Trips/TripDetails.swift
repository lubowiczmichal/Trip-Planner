//
//  TripDetails.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 19/02/2021.
//

import SwiftUI

struct TripDetails: View {
    
    var trip:Trip
    @ObservedObject var upload = NewTripViewModel()
    
    var body: some View {
        VStack{
            ZStack{
                ImageURL(name: trip.imageURL)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    .clipped()
                VStack{
                    Spacer(minLength: UIScreen.main.bounds.width*0.8)
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
                    Button(action: {
                        upload.deletePhoto(name: trip.imageURL)
                    }) {
                        Text("delete")
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35)
            }
            ScrollView{
                Text(trip.description)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
    }
}

struct TripDetails_Previews: PreviewProvider {
    static var previews: some View {
        TripDetails(trip: Trip(id: "1", name: "Polska", description: "Polsk", imageURL: "https://meteor-turystyka.pl/images/places/0/36.jpg", dateStart: Date(), dateEnd: Date()))
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
