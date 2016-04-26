//
//  LostFoundItem.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/4/22.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import ObjectMapper

class LostFoundItem: NSObject, Mappable {
    
    var index = ""
    var name = ""
    var title = ""
    var place = ""
    var time = ""
    var phone = ""
    var lostType = 0
    var otherTag = ""
    var foundPic = ""
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        index <- map["id"]
        name <- map["name"]
        title <- map["title"]
        place <- map["place"]
        time <- map["time"]
        phone <- map["phone"]
        lostType <- map["lost_type"]
        otherTag <- map["other_tag"]
        foundPic <- map["found_pic"]
    }
}
