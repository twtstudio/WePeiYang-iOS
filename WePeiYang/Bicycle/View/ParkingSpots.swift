//
//  ParkingSpots.swift
//  MapKitImplement
//
//  Created by Allen X on 7/11/16.
//  Copyright © 2016 twtstudio. All rights reserved.
//

import MapKit

class ParkingSpots: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    var numberOfBikes: Int
    var currentNumberOfBikes: Int?
    
    
    
    init(title: String?, coordinate: CLLocationCoordinate2D, numberOfBikes: Int) {
        self.title = title!
        self.coordinate = coordinate
        self.numberOfBikes = numberOfBikes
    }
    
    /*
     var currentNumberOfBikes: Int? {
     return self.currentNumberOfBikes
     }*/
    
}
