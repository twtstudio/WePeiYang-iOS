//
//  LostFoundTypeTransformer.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/15.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class LostFoundTypeTransformer: NSValueTransformer {
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        if value != nil {
            switch (value as! String) {
            case "1":
                return "银行卡"
            case "2":
                return "饭卡 & 身份证"
            case "3":
                return "钥匙"
            case "4":
                return "书包"
            case "5":
                return "电脑包"
            case "6":
                return "手表 & 饰品"
            case "7":
                return "U 盘 & 硬盘"
            case "8":
                return "水杯"
            case "9":
                return "书"
            case "10":
                return "手机"
            case "0":
                return "其他"
            default:
                break
            }
        }
        return value
    }

}
