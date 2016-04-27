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
    
<<<<<<< HEAD
    var desc: String!
    var iconUrl: String!
    var name: String!
    var sites: String!
    var requireLogin = Bool()
    var requireFullscreen = Bool()
    
=======
    var desc = ""
    var iconUrl = ""
    var name = ""
    var sites = ""
    var fullScreen = false
>>>>>>> xnth97/master
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        desc <- map["description"]
        iconUrl <- map["icon_url"]
        name <- map["name"]
        sites <- map["sites"]
<<<<<<< HEAD
        requireLogin <- map["requireLogin"]
        requireFullscreen <- map["requireFullScreen"]
=======
        fullScreen <- map["requireFullScreen"]
>>>>>>> xnth97/master
    }

}
