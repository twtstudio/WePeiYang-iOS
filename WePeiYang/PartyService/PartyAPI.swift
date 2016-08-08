//
//  PartyAPI.swift
//  WePeiYang
//
//  Created by Allen X on 8/6/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

struct PartyAPI {
    static let rootURL = "http://www.twt.edu.cn/party"
    
    //Only for test
    //static let studentID = "3015218062"
    
    static var studentID: String? {
        guard let foo = Applicant.sharedInstance.studentNumber else {
            return nil
        }
        return foo
    }

    

    //个人信息参数
    static let personalStatusParams = ["page": "api", "do": "personalstatus", "sno": studentID!]
    
    static let applicantEntryParams = ["page": "api", "do": "applicant_entry", "sno": studentID!]
    
    //20 课简要列表，不知道 sno 要不要传
    static let courseStudyParams = ["page": "api", "do": "applicant_coursestudy", "sno": studentID!]
    
    static func courseStudyDetailParams (of courseID: String) -> [String: String] {
        return ["page": "api", "do": "applicant_coursestudy_detail", "course_id": courseID, "sno": studentID!]
    }
    
    //预备党员党校课程学习之理论经典
    static let studyTextParams = ["page": "api", "do": "study_text"]
    
    static func studyTextDetailParams (of textID: String) -> [String: String] {
        return ["page": "api", "do": "study_textArticle", "file_type": textID]
    }
    
    static let scoreInfoParams = ["page": "api", "do": "20score", "sno": studentID!]
}
