//
//  ApplicantTest.swift
//  WePeiYang
//
//  Created by Allen X on 8/18/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//


struct ApplicantTest {
    
    
    struct ApplicantEntry {
        static var status: Int? = nil
        static var message: String? = nil
        
        static var testInfo: TestInfo? = nil
        
        struct TestInfo {
            let id: String?
            let name: String?
            let beginTime: String?
            let attention: String?
            let fileName: String?
            let filePath: String?
            let status: String?
            let isDeleted: String?
        }
        
        static func getStatus(and completion: () -> ()) {
            let manager = AFHTTPSessionManager()
            manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
            manager.GET(PartyAPI.rootURL, parameters: PartyAPI.applicantEntryParams, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                guard responseObject != nil else {
                    MsgDisplay.showErrorMsg("网络不好，请稍候再试")
                    return
                }
                
                guard responseObject?.objectForKey("status") as? Int == 1 else {
                    guard let msg = responseObject?.objectForKey("msg") as? String else {
                        ApplicantEntry.message = "无相关信息"
                        ApplicantEntry.status = 0
                        completion()
                        return
                    }
                    
                    ApplicantEntry.message = msg
                    ApplicantEntry.status = 0
                    completion()
                    return
                }
                
                ApplicantEntry.status = 1
                guard let fooInfo = responseObject?.objectForKey("test_info") as? NSDictionary else {
                    ApplicantEntry.status = 0
                    ApplicantEntry.message = "暂时无法报名"
                    completion()
                    return
                }
                
                guard let id = fooInfo["test_id"] as? String,
                      let name = fooInfo["test_name"] as? String,
                      let beginTime = fooInfo["test_begintime"] as? String
                    else {
                        ApplicantEntry.status = 0
                        ApplicantEntry.message = "暂时无法报名"
                        completion()
                        return
                }
                
                let attention = fooInfo["test_attention"] as? String
                let fileName = fooInfo["test_filename"] as? String
                let filePath = fooInfo["test_filepath"] as? String
                let status = fooInfo["test_status"] as? String
                let isDeleted = fooInfo["test_isdeleted"] as? String
                
                AcademyEntry.status = 1
                AcademyEntry.message = name
                
                testInfo = TestInfo(id: id, name: name, beginTime: beginTime, attention: attention, fileName: fileName, filePath: filePath, status: status, isDeleted: isDeleted)
                
                completion()
                
            }) { (_: NSURLSessionDataTask?, _: NSError) in
                    MsgDisplay.showErrorMsg("出错啦！")
            }
        }
        
        static func signUp(forID testID: String, and completion: () -> ()) {
            log.word("entered signUp")/
            let manager = AFHTTPSessionManager()
            manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
            
            manager.GET(PartyAPI.rootURL, parameters: PartyAPI.applicantEntry2Params(of: testID), success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                
                guard responseObject != nil else {
                    MsgDisplay.showErrorMsg("报名失败，请稍后重试")
                    return
                }
                
                guard responseObject?.objectForKey("status") as? Int == 1 else {
                    guard let msg = responseObject?.objectForKey("msg") as? String else {
                        MsgDisplay.showErrorMsg("报名失败，请稍后重试")
                        return
                    }
                    
                    MsgDisplay.showErrorMsg(msg)
                    return
                }
                
                ApplicantEntry.status = 0
                guard let msg = responseObject?.objectForKey("msg") as? String else {
                    ApplicantEntry.message = "请稍候查看消息"
                    completion()
                    return
                }
                
                ApplicantEntry.message = msg
                completion()
                
            }) { (_: NSURLSessionDataTask?, err: NSError) in
                    MsgDisplay.showErrorMsg("报名失败，请稍后再试")
            }
        }
    }


    
    struct AcademyEntry {
        
        static var status: Int? = nil
        static var message: String? = nil
        
        static var testInfo: TestInfo? = nil
        
        struct TestInfo {
            let id: String?
            let name: String?
            let beginTime: String?
            let attention: String?
            let fileName: String?
            let filePath: String?
            let status: String?
            let isDeleted: String?
        }
    
        static func getStatus(and completion: () -> ()) {
            let manager = AFHTTPSessionManager()
            manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
            manager.GET(PartyAPI.rootURL, parameters: PartyAPI.applicantEntryParams, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                guard responseObject != nil else {
                    MsgDisplay.showErrorMsg("网络不好，请稍候再试")
                    return
                }
                
                guard responseObject?.objectForKey("status") as? Int == 1 else {
                    guard let msg = responseObject?.objectForKey("msg") as? String else {
                        AcademyEntry.message = "无相关信息"
                        AcademyEntry.status = 0
                        completion()
                        return
                    }
                    
                    AcademyEntry.message = msg
                    AcademyEntry.status = 0
                    completion()
                    return
                }
                
                AcademyEntry.status = 1
                guard let fooInfo = responseObject?.objectForKey("test_info") as? NSDictionary else {
                    AcademyEntry.status = 0
                    AcademyEntry.message = "暂时无法报名"
                    return
                }
                
                guard let id = fooInfo["test_id"] as? String,
                    let name = fooInfo["test_name"] as? String,
                    let beginTime = fooInfo["test_begintime"] as? String
                    else {
                        AcademyEntry.status = 0
                        AcademyEntry.message = "暂时无法报名"
                        return
                }
                
                let attention = fooInfo["test_attention"] as? String
                let fileName = fooInfo["test_filename"] as? String
                let filePath = fooInfo["test_filepath"] as? String
                let status = fooInfo["test_status"] as? String
                let isDeleted = fooInfo["test_isdeleted"] as? String
                
                AcademyEntry.status = 1
                AcademyEntry.message = name
                
                testInfo = TestInfo(id: id, name: name, beginTime: beginTime, attention: attention, fileName: fileName, filePath: filePath, status: status, isDeleted: isDeleted)
                
                completion()
                
            }) { (_: NSURLSessionDataTask?, _: NSError) in
                MsgDisplay.showErrorMsg("出错啦！")
            }
        }
        
        static func signUp(forID testID: String, and completion: () -> ()) {
            let manager = AFHTTPSessionManager()
            manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
            manager.GET(PartyAPI.rootURL, parameters: PartyAPI.applicantEntry2Params(of: testID), success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                
                guard responseObject != nil else {
                    MsgDisplay.showErrorMsg("报名失败，请稍后重试")
                    return
                }
                
                guard responseObject?.objectForKey("status") as? Int == 1 else {
                    guard let msg = responseObject?.objectForKey("msg") as? String else {
                        MsgDisplay.showErrorMsg("报名失败，请稍后重试")
                        return
                    }
                    
                    MsgDisplay.showErrorMsg(msg)
                    return
                }
                
                AcademyEntry.status = 0
                guard let msg = responseObject?.objectForKey("msg") as? String else {
                    AcademyEntry.message = "请稍候查看消息"
                    completion()
                    return
                }
                
                AcademyEntry.message = msg
                
                completion()
                
            }) { (_: NSURLSessionDataTask?, err: NSError) in
                MsgDisplay.showErrorMsg("报名失败，请稍后再试")
            }
        }
        
        
    }
    
    struct ProbationaryEntry {
        
    }
}
