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
        week <- map["week"]
        day <- map["day"]
        start <- map["start"]
        end <- map["end"]
        room <- map["room"]
    }

}
