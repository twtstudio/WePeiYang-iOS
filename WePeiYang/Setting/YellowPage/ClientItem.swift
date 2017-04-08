//
//  ClientItem.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/22.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import Foundation

class ClientItem: NSObject, NSCoding {
    var name = ""
    var phone = ""
    var isFavorite = false
    var owner: String = ""
    
    init(with name: String, phone: String, owner: String) {
        self.name = name
        self.phone = phone
        self.owner = owner
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("yp_name") as! String
        phone = aDecoder.decodeObjectForKey("yp_phone") as! String
        isFavorite = aDecoder.decodeObjectForKey("yp_isFavorite") as! Bool
        owner = aDecoder.decodeObjectForKey("yp_owner") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "yp_name")
        aCoder.encodeObject(phone, forKey: "yp_phone")
        aCoder.encodeObject(isFavorite, forKey: "yp_isFavorite")
        aCoder.encodeObject(owner, forKey: "yp_owner")
    }
    
}
