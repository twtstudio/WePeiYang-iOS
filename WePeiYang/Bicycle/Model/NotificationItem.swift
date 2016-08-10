//
//  NotificationItem.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class NotificationItem: NSObject {
    
    var id: String = "" //坑：类型
    var title: String = ""
    var content: String = ""
    var timeStamp: NSDate = NSDate()
    var second: Int = 0
    
    init(dict: NSDictionary) {
        
        id = dict.objectForKey("id") as! String
        title = dict.objectForKey("title") as! String
        content = dict.objectForKey("content") as! String
        
        let timeStampString = dict.objectForKey("timestamp") as? String
        second = Int(timeStampString!)!
        timeStamp = NSDate(timeIntervalSince1970: Double(second))
    }
    
}
