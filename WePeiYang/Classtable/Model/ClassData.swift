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
    var weekStart = 0
    var weekEnd = 0
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
        weekEnd <- map["week.end"]
        college <- map["college"]
        campus <- map["campus"]
        ext <- map["ext"]
    }
    
}
