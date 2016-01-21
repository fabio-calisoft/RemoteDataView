//
//  SurfSpot.swift
//  RemoteDataTableView
//
//  Created by Fabio De Lorenzo on 1/20/16.
//  Copyright © 2016 Crokky Software Inc. All rights reserved.
//

import Foundation


/**
 Class describing a surf spot
 no methods are included. Used only to hold the surf spot data
 */
class SurfSpot {
    
    var location: String?
    var waves_min: String?
    var waves_max: String?
    var low_tide: String?
    var high_tide: String?
    var imageurl: String?
    var report: String?
    init(spot: [String: String] ) {
        self.location = spot["location"]
        self.waves_min = spot["waves_min"]
        self.waves_max = spot["waves_max"]
        self.low_tide = spot["low_tide"]
        self.high_tide = spot["high_tide"]
        self.imageurl = spot["imageurl"]
        self.report = spot["report"]
    }
}