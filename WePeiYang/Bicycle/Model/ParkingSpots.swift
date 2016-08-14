//
//  ParkingSpots.swift
//  MapKitImplement
//
//  Created by Allen X on 7/11/16.
//  Copyright © 2016 twtstudio. All rights reserved.
//

import MapKit
import SwiftyJSON


class ParkingSpot: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    var numberOfBikes: Int
    var currentNumberOfBikes: Int?
    
    static var parkingSpots: [ParkingSpot]? {
        
        var foo: [ParkingSpot]? = []
        
        guard let jsonPath = NSBundle.mainBundle().pathForResource("ParkingSpotsLocs", ofType: "json") else {
            //Do fetch JSON file from the server
            log.word("fuck1")/
            return nil
        }
        
        guard let jsonData = NSData(contentsOfFile: jsonPath) else {
            log.word("fuck2")/
            return nil
        }
        
        guard let jsonObj = (try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers))! as? NSDictionary else {
            log.word("fuck3")/
            return nil
        }
        
        guard let arr = jsonObj["data"] as? Array<NSDictionary> else {
            log.word("fuck4")/
            return nil
        }
        
        /*
         //MARK: 此 flatMap 方法有问题
         return arr.flatMap({ (dict: NSDictionary) -> ParkingSpots? in
         //let id = dict["id"] as? String,
         guard let title = dict["name"] as? String
         let campus = dict["campus"] as? Int,
         let latitude_c = dict["lat_c"] as? Double,
         let longtitude_c = dict["lng_c"] as? Double
         else {
         log.word("fuck5")/
         return nil
         }
         let coordinate = CLLocationCoordinate2D(latitude: latitude_c, longitude: longtitude_c)
         return ParkingSpots(title: title, coordinate: coordinate, numberOfBikes: 0)
         })*/
        
        for dict in arr {
            guard let id = dict["id"] as? Int,
                let title = dict["name"] as? String,
                let campus = dict["campus"] as? Int,
                let latitude_c = dict["lat_c"] as? Double,
                let longitude_c = dict["lng_c"] as? Double
                else {
                    return nil
            }
            let coordinate = CLLocationCoordinate2D(latitude: latitude_c, longitude: longitude_c)
            let newSpot = ParkingSpot(title: title, coordinate: coordinate, numberOfBikes: 0)
            foo?.append(newSpot)
        }
        return foo
    }
    
    init(title: String?, coordinate: CLLocationCoordinate2D, numberOfBikes: Int) {
        self.title = title!
        self.coordinate = coordinate
        self.numberOfBikes = numberOfBikes
    }
    
}

//网络请求获得实时状况
extension ParkingSpot {
    
}