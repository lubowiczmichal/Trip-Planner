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
                    .font(.system(size: 20))
                    .multilineTextAlignment(.leading)
                Text(trip.dateStartString + " - " + trip.dateEndString)
                    .font(.system(size: 15))
                Text("\(trip.daysToStart) days left")
                    .font(.system(size: 15))
            }
        }
    }
}

struct TripInfo_Previews: PreviewProvider {
    static var previews: some View {
        TripDetails(trip: TripRepository().trips[0])
    }
}
