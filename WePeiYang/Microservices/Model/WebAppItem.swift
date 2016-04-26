//
//  WebAppItem.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/4/21.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import ObjectMapper

class WebAppItem: NSObject, Mappable {
    
    var desc = ""
    var iconUrl = ""
    var name = ""
    var sites = ""
    var fullScreen = false
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        desc <- map["description"]
        iconUrl <- map["icon_url"]
        name <- map["name"]
        sites <- map["sites"]
        fullScreen <- map["requireFullScreen"]
    }

}
