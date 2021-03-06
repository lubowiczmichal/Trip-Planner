//
//  TripsList.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 19/02/2021.
//

import SwiftUI

struct TripsList: View {
    
    @ObservedObject var repo = TripRepository()
    @State private var showNew = false
    
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
                    ForEach(repo.trips.sorted{$0.dateStart < $1.dateStart}){trip in
                        NavigationLink(destination: TripDetails(trip: trip)) {
                            TripInfo(trip: trip)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .navigationTitle("Yours Trips")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Text("")
                            NavigationLink(destination: NewTrip()) {
                                Text("Add new trip")
                            }
                        }
                    }
                }
            }
        }
        .onAppear(){
            repo.loadData()
        }
    }
}

struct TripsList_Previews: PreviewProvider {
    static var previews: some View {
        TripsList()
    }
}
