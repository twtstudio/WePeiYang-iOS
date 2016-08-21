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
    let id: Int
    let title: String?
    let coordinate: CLLocationCoordinate2D
    var numberOfBikes: Int
    var currentNumberOfBikes: Int?
    var status: Status?
    
    enum Status: String {
        case online = "该点运行良好"
        case offline = "该停车位已掉线，数据可能不是最新"
        case dunno = "该点运行状态未知"
    }
    
    static var parkingSpots: [ParkingSpot]? {
        
        var foo: [ParkingSpot]? = []
        
        guard let jsonPath = NSBundle.mainBundle().pathForResource("ParkingSpotsLocs", ofType: "json") else {
            //Do fetch JSON file from the server
            //log.word("fuck1")/
            return nil
        }
        
        guard let jsonData = NSData(contentsOfFile: jsonPath) else {
            //log.word("fuck2")/
            return nil
        }
        
        guard let jsonObj = (try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers))! as? NSDictionary else {
            //log.word("fuck3")/
            return nil
        }
        
        guard let arr = jsonObj["data"] as? Array<NSDictionary> else {
            //log.word("fuck4")/
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
         //log.word("fuck5")/
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
            let newSpot = ParkingSpot(id: id, title: title, coordinate: coordinate, numberOfBikes: 0)
            foo?.append(newSpot)
        }
        return foo
    }
    
    
    init(id: Int, title: String?, coordinate: CLLocationCoordinate2D, numberOfBikes: Int) {
        self.id = id
        self.title = title!
        self.coordinate = coordinate
        self.numberOfBikes = numberOfBikes
    }
    
}


//Calculate Distance
extension ParkingSpot {
    
    func calculateDistance(userLocation: MKUserLocation) -> CLLocationDistance {
        
        let spotLoc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let userLoc = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        return spotLoc.distanceFromLocation(userLoc)
        
    }
}

//网络请求获得实时状况
extension ParkingSpot {
    
    //单个点获得状态，用于点击后获取
    func getCurrentStatus(and completion: () -> ()) {
        let manager = AFHTTPSessionManager()
        let parameters = ["station": id]
        manager.GET(BicycleAPIs.statusURL, parameters: parameters, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            guard responseObject != nil else {
                MsgDisplay.showErrorMsg("网络不好，请稍候再试")
                return
            }
            
            guard responseObject?.objectForKey("errno") as? Int == 0 else {
                guard let msg = responseObject?.objectForKey("errmsg") as? String else {
                    MsgDisplay.showErrorMsg("哎呀，未知错误")
                    return
                }
                MsgDisplay.showErrorMsg("服务器出错啦，错误信息：" + msg)
                return
            }
            
            guard let fooStatus = responseObject?.objectForKey("data") as? Array<NSDictionary> else {
                MsgDisplay.showErrorMsg("哎呀，未知错误1")
                return
            }
            
            guard fooStatus.count == 1 else {
                MsgDisplay.showErrorMsg("哎呀，未知错误2")
                return
            }
            
            guard let foo = fooStatus[0]["status"] as? String else {
                //self.statusMsg = "该点运行状态未知"
                self.status = Status.dunno
                return
            }
            if foo == "0" {
                //self.statusMsg = Status.offline.rawValue
                self.status = Status.offline
            } else {
                //self.statusMsg = Status.online.rawValue
                self.status = Status.online
            }
            
            guard let numberOfBikes = fooStatus[0]["total"] as? String,
                  let currentNumberOfBikes = fooStatus[0]["used"] as? String
                else {
                    MsgDisplay.showErrorMsg("哎呀，未知错误3")
                    return
            }
            self.numberOfBikes = Int(numberOfBikes)!
            self.currentNumberOfBikes = Int(currentNumberOfBikes)
            
            completion()
        }) { (task: NSURLSessionDataTask?, err: NSError) in
            MsgDisplay.showErrorMsg("网络不好，请重试")
        }
    }
    
    //用于对一个 [ParkingSpot] 获取状态，智能对一定区域内点预加载 (放进 userdefaults)
    static func getCurrentStatusForList(list: [ParkingSpot], and completion: () -> ()) {
        let manager = AFHTTPSessionManager()
        var parameters: [String: String] {
            var foo = ""
            for spot in list {
                foo += "\(spot.id), "
            }
            return ["station": foo.removeCharsFromEnd(2)]
        }
        
        manager.GET(BicycleAPIs.statusURL, parameters: parameters, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
            var fooStatusArr: [[String: String]]
            
            guard responseObject != nil else {
                MsgDisplay.showErrorMsg("网络不好，请稍候再试")
                return
            }
            
            guard responseObject?.objectForKey("errno") as? Int == 0 else {
                guard let msg = responseObject?.objectForKey("errmsg") as? String else {
                    MsgDisplay.showErrorMsg("哎呀，未知错误")
                    return
                }
                MsgDisplay.showErrorMsg("服务器出错啦，错误信息：" + msg)
                return
            }
            
            guard let fooStatus = responseObject?.objectForKey("data") as? Array<NSDictionary> else {
                MsgDisplay.showErrorMsg("哎呀，未知错误")
                return
            }

            for i in 0..<list.count {
                guard let numberOfBikes = fooStatus[i]["total"] as? String,
                    let currentNumberOfBikes = fooStatus[i]["used"] as? String
                    else {
                        MsgDisplay.showErrorMsg("哎呀，未知错误3")
                        return
                }
                list[i].numberOfBikes = Int(numberOfBikes)!
                list[i].currentNumberOfBikes = Int(currentNumberOfBikes)
            }
            
            //以下的 for in 有问题（会导致几个一样）
            /*
            for spot in list {
                for status in fooStatus {
                    guard let numberOfBikes = status["total"] as? String,
                        let currentNumberOfBikes = status["used"] as? String
                        else {
                            MsgDisplay.showErrorMsg("哎呀，未知错误3")
                            return
                    }
                    spot.numberOfBikes = Int(numberOfBikes)!
                    spot.currentNumberOfBikes = Int(currentNumberOfBikes)
                }
            }*/
            
            completion()
            
        }) { (task: NSURLSessionDataTask?, err:NSError) in
        }
    }
}


private extension String {
    
    func removeCharsFromEnd(count:Int) -> String{
        let stringLength = self.characters.count
        let substringCount = (stringLength < count) ? 0 : stringLength - count
        let index: String.Index = self.startIndex.advancedBy(substringCount)
        return self.substringToIndex(index)
    }
}