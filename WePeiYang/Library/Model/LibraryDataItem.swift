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
    
    var author = ""
    var publisher = ""
    var title = ""
    var location = ""
    var index = ""
    
    init(index: String, title: String, author: String, publisher: String, location: String) {
        self.index = index
        self.title = title
        self.author = author
        self.publisher = publisher
        self.location = location
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        author <- map["author"]
        publisher <- map["publisher"]
        title <- map["title"]
        location <- map["location"]
        index <- map["index"]
    }
    
}
