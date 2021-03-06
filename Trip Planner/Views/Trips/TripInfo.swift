//
//  TripInfo.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 19/02/2021.
//

import SwiftUI

struct TripInfo: View {
    
    @StateObject var repo = TripRepository()

    var trip: Trip
    var body: some View {
        HStack{
            Image(uiImage: repo.downloadedImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipped()
                .onAppear(){
                    repo.downloadPhoto(name: trip.imageName)
                }
            VStack{
                Text(trip.name)
                Text(trip.dateStartString + " - " + trip.dateEndString)
                Text("To start \(trip.daysToStart) days")
            }
        }
    }
}

struct TripInfo_Previews: PreviewProvider {
    static var previews: some View {
        TripInfo(trip: Trip(id: "A", name: "Wycieczka", description: "Bardzo fajna wycieczka", imageName: "", dateStart: Date(), dateEnd: Date(), itemsList: ["item1", "item2"], activeItemsList: [true, false]))
    }
}
