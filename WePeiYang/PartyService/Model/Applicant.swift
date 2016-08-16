//
//  Applicant.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class Applicant: NSObject {
    
    
    var realName: String?
    var studentNumber: String?
    var personalStatus = [NSDictionary]()
    var scoreOf20Course = [NSDictionary]()
    var applicantGrade = [NSDictionary]()
    var academyGrade = [NSDictionary]()
    var probationayGrade = [NSDictionary]()
    
    static let sharedInstance = Applicant()
    
    private override init(){}
    
    func testFunc() {
        print(self.personalStatus)
    }
    
    
    //TODO: 未完成
    func getStudentNumber(success: Void -> Void) {
        
        //TODO:这样做还不够优雅，应该在登录完成之后自动重新加载
        guard let token = NSUserDefaults.standardUserDefaults().objectForKey("twtToken") else {
            MsgDisplay.showErrorMsg("你需要登录才能访问党建功能")
            let loginVC = LoginViewController()
            UIViewController.currentViewController().presentViewController(loginVC, animated: true, completion: nil)
            return
        }
        let parameters = ["token": token]
        //let parameters = ["token": "aabbcc"]
        let manager = AFHTTPSessionManager()
        
        manager.GET("http://open.twtstudio.com/api/v2/auth/self", parameters: parameters, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
            let dic = responseObject as? NSDictionary
            
            self.realName = dic?.objectForKey("realname") as? String
            self.studentNumber = dic?.objectForKey("studentid") as? String
            
            success()
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("error: \(error)")
        })
        
    }
    
    
    func getPersonalStatus() {
        
        
        //AFNetWorking/Alamofire Works
        let parameters = ["page": "api", "do": "personalstatus", "sno": studentNumber!]
        
        let manager = AFHTTPSessionManager()
        
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        
        manager.GET(PartyAPI.rootURL, parameters: PartyAPI.personalStatusParams, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
            let dic = responseObject as? NSDictionary
            
            if dic?.objectForKey("status") as? NSNumber == 1 {
                self.personalStatus = dic?.objectForKey("status_id") as! [NSDictionary]
                print(self.personalStatus)
            } else {
                MsgDisplay.showErrorMsg(dic?.objectForKey("msg") as? String)
            }
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("error: \(error)")
        })
        
    }
    
    
    func get20score(doSomething: () -> ()) {
        
        //let parameters = ["page": "api", "do": "20score", "sno": studentNumber!]
        let parameters = ["page": "api", "do": "20score", "sno": "3015218062"]
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        
        manager.GET(PartyAPI.rootURL, parameters: parameters, progress: { (progress: NSProgress) in
            
            MsgDisplay.showLoading()
            
            },success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
            let dic = responseObject as? NSDictionary
            log.obj(dic!)/
            if dic?.objectForKey("status") as? NSNumber == 1 {
                self.scoreOf20Course = dic?.objectForKey("score_info") as! [NSDictionary]
                print(self.scoreOf20Course)
            } else {
                MsgDisplay.showErrorMsg(dic?.objectForKey("msg") as? String)
                return
            }
                
            MsgDisplay.dismiss()
            
            doSomething()
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("error: \(error)")
        })
        
    }
    
    func getApplicantGrade(doSomething: () -> ()) {
        
        let parameters = ["page": "api", "do": "applicant_gradecheck", "sno": studentNumber!]
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        manager.GET(PartyAPI.rootURL, parameters: parameters, progress: { (progress: NSProgress) in
            
                MsgDisplay.showLoading()
            
            },success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
                let dic = responseObject as? NSDictionary
            
                guard dic?.objectForKey("status") as? NSNumber == 1 else {
                    MsgDisplay.showErrorMsg(dic?.objectForKey("msg") as? String)
                    return
                }
            
                let dict = dic?.objectForKey("data")
                self.applicantGrade = dict as! [NSDictionary]
                print(self.applicantGrade)
                MsgDisplay.dismiss()
            
            
                doSomething()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("error: \(error)")
        })
    }
    
    func getAcademyGrade() {
        
        let parameters = ["page": "api", "do": "academy_gradecheck", "sno": studentNumber!]
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        manager.GET(PartyAPI.rootURL, parameters: parameters, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
            let dic = responseObject as? NSDictionary
            if dic?.objectForKey("status") as? NSNumber == 1 {
                self.academyGrade = dic?.objectForKey("0") as! [NSDictionary]
                print(self.academyGrade)
            } else {
                MsgDisplay.showErrorMsg(dic?.objectForKey("msg") as? String)
            }
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("error: \(error)")
        })
    }
    
    func getProbationayGrade() {
        
        let parameters = ["page": "api", "do": "probationay_gradecheck", "sno": studentNumber!]
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        manager.GET(PartyAPI.rootURL, parameters: parameters, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
            let dic = responseObject as? NSDictionary
            
            if dic?.objectForKey("status") as? NSNumber == 1 {
                self.probationayGrade = dic?.objectForKey("0") as! [NSDictionary]
                print(self.probationayGrade)
            } else {
                MsgDisplay.showErrorMsg(dic?.objectForKey("msg") as? String)
            }
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("error: \(error)")
        })
    }
    
    
    
    
    
}
