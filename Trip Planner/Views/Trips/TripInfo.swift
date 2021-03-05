//
//  TripInfo.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 19/02/2021.
//

import SwiftUI

struct TripInfo: View {
    
    @ObservedObject var upload = NewTripViewModel()
    
    var trip: Trip
    var body: some View {
        HStack{
            upload.downloadPhoto(name: trip.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipped()
            VStack{
                Text(trip.name)
                    .font(.system(size: 15))
                    .foregroundColor(Color.red)
                Text(trip.description)
                    .font(.system(size: 10))
                Text(trip.dateStartString + " - " + trip.dateEndString)
                    .font(.system(size: 10))
                Text("To start \(trip.daysToStart) days")
                    .font(.system(size: 10))
            }
            .onAppear(){
                print(trip)
                print(trip.dateStart)
            }
        }
    }
}

struct TripInfo_Previews: PreviewProvider {
    static var previews: some View {
        TripInfo(trip: TripRepository().trips[0])
    }
}
