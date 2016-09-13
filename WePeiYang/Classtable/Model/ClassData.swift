//
//  ClassData.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/5/8.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import ObjectMapper

class ClassData: NSObject, Mappable {
    
    var classId = ""
    var courseId = ""
    var courseName = ""
    var courseType = ""
    var courseNature = ""
    var credit = ""
    var teacher = ""
    var arrange: [ArrangeModel] = []
    //The weekStart and End were previously of type Int but the mapper can only map it into String -Allen on Sept-14-2016
    var weekStart = ""
    var weekEnd = ""
    var college = ""
    var campus = ""
    var ext = ""
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        classId <- map["classid"]
        courseId <- map["courseid"]
        courseName <- map["coursename"]
        courseType <- map["coursetype"]
        courseNature <- map["coursenature"]
        credit <- map["credit"]
        teacher <- map["teacher"]
        arrange <- map["arrange"]
        weekStart <- map["week.start"]
        //log.any("fucking map thing \(courseName)")/
        //log.any("fucking fucking map thing \(map["week.start"])")/
        weekEnd <- map["week.end"]
        college <- map["college"]
        campus <- map["campus"]
        ext <- map["ext"]
    }
    
}
