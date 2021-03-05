//
//  TripsListViewModel.swift
//  Trip Planner
//
//  Created by Michał Lubowicz on 26/02/2021.
//

import Foundation
import Combine
import SwiftUI
import Firebase
import FirebaseStorage


class TripsListViewModel: ObservableObject{
    @Published var tripRepository = TripRepository()
    
    init(){
        tripRepository.$trips.map{ trip in
        }
    } 
}
