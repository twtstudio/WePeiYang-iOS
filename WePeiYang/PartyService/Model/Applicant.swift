//
//  Applicant.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class Applicant: NSObject {
    
    //FIXME: 还是需要保证数据的正确，再加载UI
    var realName: String? = NSUserDefaults.standardUserDefaults().objectForKey("studentName") as? String
    var studentNumber: String? = NSUserDefaults.standardUserDefaults().objectForKey("studentID") as? String
    var personalStatus = [NSDictionary]()
    var scoreOf20Course = [NSDictionary]()
    var applicantGrade = [NSDictionary]()
    var academyGrade = [NSDictionary]()
    var probationaryGrade = [NSDictionary]()
    var handInHandler: NSDictionary?
    
    static let sharedInstance = Applicant()
    
    private override init(){}
    
    //TODO: 未完成
    func getStudentNumber(success: Void -> Void) {
        
        //TODO:这样做还不够优雅，应该在登录完成之后自动重新加载
        guard let token = NSUserDefaults.standardUserDefaults().objectForKey("twtToken") else {
            MsgDisplay.showErrorMsg("你需要登录才能访问党建功能")
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            UIViewController.currentViewController().presentViewController(loginVC, animated: true, completion: nil)
            return
        }
        let parameters = ["token": token]
        //let parameters = ["token": "aabbcc"]
        let manager = AFHTTPSessionManager()
        
        manager.GET("http://open.twtstudio.com/api/v2/auth/self", parameters: parameters, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
            let dic = responseObject as? NSDictionary
            
            guard let fooRealName = dic?.objectForKey("realname") as? String,
                let fooStudentNumber = dic?.objectForKey("studentid") as? String else {
                MsgDisplay.showErrorMsg("获取学号失败，请稍候再试")
                    return
            }
            
            self.realName = fooRealName
            self.studentNumber = fooStudentNumber
            

            NSUserDefaults.standardUserDefaults().setObject(self.studentNumber, forKey: "studentID")
            NSUserDefaults.standardUserDefaults().setObject(self.realName, forKey: "studentName")
            //log.word("registered!")/

            success()
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                print("error: \(error)")
        })
        
    }
    
    
    func getPersonalStatus(doSomething: () -> ()) {
        
        
        //AFNetWorking/Alamofire Works
        
        let manager = AFHTTPSessionManager()
        
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        
        manager.GET(PartyAPI.rootURL,
                    parameters: PartyAPI.personalStatusParams,
                    progress: { (progress: NSProgress) in
                        MsgDisplay.showLoading()
                    },
                    success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
                        let dic = responseObject as? NSDictionary
            
                        guard dic?.objectForKey("status") as? NSNumber == 1 else {
                            MsgDisplay.showErrorMsg(dic?.objectForKey("msg") as? String)
                            return
                        }
                        
                        guard let fooPersonalStatus = dic?.objectForKey("status_id") as? [NSDictionary] else {
                            MsgDisplay.showErrorMsg("获取个人状态失败，请稍后再试")
                            return
                        }
                        
                        self.personalStatus = fooPersonalStatus
                        MsgDisplay.dismiss()
                        doSomething()
                    },
                    failure: { (task: NSURLSessionDataTask?, error: NSError) in
                        MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                        print("error: \(error)")
                    }
        )
        
    }
    
    
    func get20score(doSomething: () -> ()) {
        
        let parameters = ["page": "api", "do": "20score", "sno": studentNumber!]
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        
        //真是诡异的代码风格
        manager.GET(PartyAPI.rootURL,
                    parameters: parameters,
                    progress: { (progress: NSProgress) in
                        MsgDisplay.showLoading()
                    },
                    success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                        let dic = responseObject as? NSDictionary
                        //log.obj(dic!)/
                        if dic?.objectForKey("status") as? NSNumber == 1 {
                            self.scoreOf20Course = dic?.objectForKey("score_info") as! [NSDictionary]
                            //print(self.scoreOf20Course)
                        } else {
                            MsgDisplay.showErrorMsg(dic?.objectForKey("msg") as? String)
                            return
                        }
                
                        MsgDisplay.dismiss()
            
                        doSomething()
            
                    },
                    failure: { (task: NSURLSessionDataTask?, error: NSError) in
                        MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                        print("error: \(error)")
                    }
        )
        
    }
    
    func getGrade(testType: String, doSomething: () -> ()) {
        
        let parameters = ["page": "api", "do": "\(testType)_gradecheck", "sno": studentNumber!]

        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        
        manager.GET(PartyAPI.rootURL,
                    parameters: parameters,
                    progress: { (progress: NSProgress) in
                        MsgDisplay.showLoading()
                    },
                    success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
                        let dic = responseObject as? NSDictionary
            
                        guard dic?.objectForKey("status") as? NSNumber == 1 else {
                            MsgDisplay.showErrorMsg(dic?.objectForKey("message") as? String)
                            return
                        }
            
                        let dict = dic?.objectForKey("data")
                
                        guard let fooGrade = dict as? [NSDictionary] else {
                            MsgDisplay.showErrorMsg("获取成绩失败，请稍后再试")
                            return
                        }
                        
                        if testType == "applicant" {
                            self.applicantGrade = fooGrade
                        } else if testType == "academy" {
                            self.academyGrade = fooGrade
                        } else if testType == "probationary" {
                            self.probationaryGrade = fooGrade
                        }
                
                        MsgDisplay.dismiss()
            
                        doSomething()
                    },
                    failure: { (task: NSURLSessionDataTask?, error: NSError) in
                        MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                        print("error: \(error)")
                    }
        )
        
    }
    
    func complain(ID: String, testType: String, title: String, content: String, doSomething: () -> ()) {
        
        let parameters = ["page": "api", "do": "\(testType)_shensu", "sno": studentNumber!, "test_id": ID, "title": title, "content": content]
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        
        manager.GET(PartyAPI.rootURL,
                    parameters: parameters,
                    progress: { (progress: NSProgress) in
                        MsgDisplay.showLoading()
                    },
                    success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                        let dic = responseObject as? NSDictionary
            
                        guard dic?.objectForKey("status") as? NSNumber == 1 else {
                            MsgDisplay.showErrorMsg(dic?.objectForKey("message") as! String)
                            return
                        }
                        
                        MsgDisplay.showSuccessMsg(dic?.objectForKey("msg") as! String)
                        doSomething()
                    },
                    failure: { (task: NSURLSessionDataTask?, error: NSError) in
                        MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                        print("error: \(error)")
                    }
        )
        
        
    }
    
    func handIn(title: String, content: String, fileType: Int, doSomething: () -> ()) {
        let parameters = ["message_title": title, "message_content": content, "submit": "", "file_type": fileType]
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        
        manager.POST(PartyAPI.handInURL,
                    parameters: parameters,
                    progress: { (progress: NSProgress) in
                        MsgDisplay.showLoading()
                    },
                    success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                        let dic = responseObject as? NSDictionary
                        
                        print(dic)
                        
                        guard dic?.objectForKey("status") as? NSNumber == 1 else {
                            MsgDisplay.showErrorMsg(dic?.objectForKey("msg") as! String)
                            return
                        }
                        
                        if let msg = dic?.objectForKey("msg") as? String {
                            MsgDisplay.showSuccessMsg(msg)
                        } else {
                            MsgDisplay.showSuccessMsg("递交成功")
                        }
                        
                        doSomething()
                    },
                    failure: { (task: NSURLSessionDataTask?, error: NSError) in
                        MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                        print("error: \(error)")
            }
        )
        
    }
    
    func handlePersonalStatus(doSomething: () -> ()) {
        
        for dict in personalStatus {
            guard dict.objectForKey("status") as? Int == 1 else {
                continue
            }
            
            guard dict.objectForKey("type") as? Int != nil else {
                continue
            }
            
            handInHandler = dict
            doSomething()
            return
        }
        
        //Nothing to hand in
        handInHandler = nil
        doSomething()
    }
    
    
}
