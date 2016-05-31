//
//  ArrangeModel.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/5/8.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import ObjectMapper

class ArrangeModel: NSObject, Mappable {
    
    var week = ""
    var day = 0
    var start = 0
    var end = 0
    var room = ""
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
            // transform value from String? to Int?
            return Int(value!)
            }, toJSON: { (value: Int?) -> String? in
                // transform value from Int? to String?
                if let value = value {
                    return String(value)
                }
                return nil
        })
        
        week <- map["week"]
        day <- (map["day"], transform)
        start <- (map["start"], transform)
        end <- (map["end"], transform)
        room <- map["room"]
    }

}
