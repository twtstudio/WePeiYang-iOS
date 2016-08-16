//
//  BicycleUser.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class BicycleUser: NSObject {
    
    //auth
    var uid: String?
    var status: NSNumber?
    var version: NSNumber?
    var bikeToken: String?
    var cradList = [Card]()
    
    //info
    var name: String?
    var balance: String?
    var duration: NSNumber?
    var recent: Array<Array<NSNumber>> = []
    var record: NSDictionary?
    
    //取消绑定时不重复要求绑定
    var bindCancel: Bool = false
    
    static let sharedInstance = BicycleUser()
    private override init() {}
    
    func auth(presentViewController: () -> ()) {
        let parameters = ["wpy_tk": "\(NSUserDefaults.standardUserDefaults().objectForKey("twtToken")!)}"]
        
        let manager = AFHTTPSessionManager()
        
        manager.POST(BicycleAPIs.authURL, parameters: parameters, progress: { (progress: NSProgress) in
            
            MsgDisplay.showLoading()
            }, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
                let dic = responseObject as? NSDictionary
                log.obj(dic!)/
                guard dic?.objectForKey("errno") as? NSNumber == 0 else {
                    MsgDisplay.showErrorMsg(dic?.objectForKey("errmsg") as? String)
                    return
                }
                
                MsgDisplay.dismiss()
                let dict = dic?.objectForKey("data") as? NSDictionary
                self.status = dict?.objectForKey("status") as? NSNumber
                self.version = dict?.objectForKey("version") as? NSNumber
                self.bikeToken = dict?.objectForKey("token") as? String
            
                presentViewController()
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                print("error: \(error)")
        })
    }
    
    func getCardlist(idnum: String, doSomething: () -> ()) {
        let parameters = ["auth_token": bikeToken!, "idnum": idnum]
        
        let manager = AFHTTPSessionManager()
        
        manager.POST(BicycleAPIs.cardURL, parameters: parameters, progress: { (progress: NSProgress) in
            
            MsgDisplay.showLoading()
            
            }, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            
                let dic = responseObject as? NSDictionary
                log.obj(dic!)/
                guard dic?.objectForKey("errno") as? NSNumber == 0 else {
                    MsgDisplay.showErrorMsg(dic?.objectForKey("errmsg") as? String)
                    return
                }
            
                MsgDisplay.dismiss()
                let list = dic?.objectForKey("data") as? NSArray
                
                for dict in list! {
                    let cardInfo = dict as? NSDictionary
                    self.cradList.append(Card(dict: cardInfo!))
                }
                doSomething()
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                print("error: \(error)")
        })
    }
    
    //未测试
    func bindCard(id: String, sign: String, doSomething: () -> ()) {
        let parameters = ["auth_token": bikeToken!, "id": id, "sign": sign]
        
        let manager = AFHTTPSessionManager()
        
        manager.POST(BicycleAPIs.bindURL, parameters: parameters, progress: { (progress: NSProgress) in
            
            MsgDisplay.showLoading()
            
            }, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                
                let dic = responseObject as? NSDictionary
                log.obj(dic!)/
                guard dic?.objectForKey("errno") as? NSNumber == 0 else {
                    MsgDisplay.showErrorMsg(dic?.objectForKey("errmsg") as? String)
                    return
                }
                
                MsgDisplay.showSuccessMsg("绑定成功！")
                doSomething()
                
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                print("error: \(error)")
        })
    }
    
    func getUserInfo(doSomething: () -> ()) {
        
        let parameters = ["auth_token": bikeToken!]
        
        let manager = AFHTTPSessionManager()
        
        manager.POST(BicycleAPIs.infoURL, parameters: parameters, progress: { (progress: NSProgress) in
            
            MsgDisplay.showLoading()
            
            }, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                
                let dic = responseObject as? NSDictionary
                log.obj(dic!)/
                guard dic?.objectForKey("errno") as? NSNumber == 0 else {
                    MsgDisplay.showErrorMsg(dic?.objectForKey("errmsg") as? String)
                    return
                }
                
                MsgDisplay.dismiss()
                
                let dict = dic?.objectForKey("data") as? NSDictionary
                self.name = dict?.objectForKey("name") as? String
                self.balance = dict?.objectForKey("balance") as? String
                self.duration = dict?.objectForKey("duration") as? NSNumber
                self.recent = dict?.objectForKey("recent") as! Array<Array<NSNumber>>
                self.record = dict?.objectForKey("record") as? NSDictionary
                
                doSomething()
                
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                print("error: \(error)")
        })
    }
    
}