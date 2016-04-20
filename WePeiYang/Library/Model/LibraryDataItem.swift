//
//  LibraryDataItem.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/4/20.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import ObjectMapper

class LibraryDataItem: NSObject, Mappable {
    
    var author: String!
    var publisher: String!
    var title: String!
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        author <- map["author"]
        publisher <- map["publisher"]
        title <- map["title"]
    }
    
}
