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
            upload.downloadPhoto(name: trip.imageName)
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            VStack{
                Text(trip.name)
                Text(trip.description)
                Text(trip.dateStartString + " - " + trip.dateEndString)
                Text("To start \(trip.daysToStart) days")
            }
        }
    }
}

struct TripInfo_Previews: PreviewProvider {
    static var previews: some View {
        TripInfo(trip: TripRepository().trips[0])
    }
}
