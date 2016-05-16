//
//  LostFoundDetail.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/4/22.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import ObjectMapper

class LostFoundDetail: NSObject, Mappable {
    
    var index = ""
    var type = 0
    var name = ""
    var title = ""
    var place = ""
    var time = ""
    var phone = ""
    var content = ""
    var lostType = 0
    var otherTag = ""
    var foundPic = ""
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        index <- map["id"]
        type <- map["type"]
        name <- map["name"]
        title <- map["title"]
        place <- map["place"]
        time <- map["time"]
        phone <- map["phone"]
        content <- map["content"]
        lostType <- map["lost_type"]
        otherTag <- map["other_tag"]
        foundPic <- map["found_pic"]
    }

}
