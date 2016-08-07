//
//  NotificationItem.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class NotificationItem: NSObject {
    
    var id: String?
    var title: String?
    var content: String?
    var timeStamp: NSDate?
    
    init(dict: NSDictionary) {
        id = String(dict["id"])
        title = String(dict["title"])
        content = String(dict["content"])
        timeStamp = NSDate(string: String(dict["timeStamp"]), formatString: "yyyy-MM-dd")
    }
    
    
    
}
