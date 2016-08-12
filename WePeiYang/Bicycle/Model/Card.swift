//
//  Card.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/9.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class Card: NSObject {
    var id: String?
    var sign: String?
    var record: NSDictionary?
    
    init(dict: NSDictionary) {
        id = dict["id"] as? String
        sign = dict["sign"] as? String
        record = dict["record"] as? NSDictionary
        /*action = dict["action"] as? NSNumber
        station = dict["station"] as? NSNumber
        dev = dict["dev"] as? NSNumber
        time = dict["time"] as? NSNumber*/
    }
}