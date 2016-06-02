//
//  DevSessionRecord.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/6/2.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class DevSessionRecord: NSObject {
    
    var id: Int?
    var type: Int?
    var parameters: [String: AnyObject]?
    var response: AnyObject?
    
    init(id: Int, type: Int, parameters: [String: AnyObject], response: AnyObject) {
        super.init()
        self.id = id
        self.type = type
        self.parameters = parameters
        self.response = response
    }

}
