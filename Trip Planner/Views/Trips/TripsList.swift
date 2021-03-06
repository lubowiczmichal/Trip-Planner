//
//  TripsList.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 19/02/2021.
//

import SwiftUI

struct TripsList: View {
    
    @ObservedObject var tripsData = TripRepository()
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
        init() {
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = UIColor.systemBackground
            UITableView.appearance().backgroundColor = UIColor.systemBackground
    }
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(tripsData.trips){trip in
                        NavigationLink(destination: TripDetails(trip: trip)) {
                            TripInfo(trip: trip)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .navigationTitle("Yours Trips")
                .toolbar {
                    NavigationLink(destination: NewTrip()) {
                        Text("Add new trip")
                    }
                }
            }

        }
        .onAppear(){
            tripsData.loadData()
        }


    }
}

struct TripsList_Previews: PreviewProvider {
    static var previews: some View {
        TripsList()
    }
}
