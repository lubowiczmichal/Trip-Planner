//
//  TripsList.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 19/02/2021.
//

import SwiftUI

struct TripsList: View {
    
    @ObservedObject var tripsData = TripRepository()
    init(){
        tripsData = TripRepository()
    }
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(tripsData.trips){trip in
                        NavigationLink(destination: TripInfo(trip: trip)) {
                            TripInfo(trip: trip)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .navigationTitle("Yours Trips")
                HStack{
                    NavigationLink(destination: NewTrip()) {
                        Text("text")
                            .background(Color.orange)
                            .padding(10)
                    }
                    Button(action: {
                        
                    }) {
                        Text("text")
                            .background(Color.red)
                            .padding(10)
                    }
                }
            }

        }
    }
}

struct TripsList_Previews: PreviewProvider {
    static var previews: some View {
        TripsList()
    }
}
