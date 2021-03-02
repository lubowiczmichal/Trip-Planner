//
//  TripInfo.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 19/02/2021.
//

import SwiftUI

struct TripInfo: View {
    
    var trip: Trip
    
    var body: some View {
        HStack{
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
