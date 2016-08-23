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
    var cardList = [Card]()
    var expire: Int?
    
    //info
    var name: String?
    var balance: String?
    var duration: String?
    var recent: Array<Array<AnyObject>> = []
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
                //log.obj(dic!)/
                guard dic?.objectForKey("errno") as? NSNumber == 0 else {
                    MsgDisplay.showErrorMsg(dic?.objectForKey("errmsg") as? String)
                    return
                }
                
                
                let dict = dic?.objectForKey("data") as? NSDictionary
                print(dict)
                guard let fooStatus = dict?.objectForKey("status") as? NSNumber,
                    let fooVersion = dict?.objectForKey("version") as? NSNumber,
                    let fooBikeToken = dict?.objectForKey("token") as? String,
                    let fooExpire = dict?.objectForKey("expire") as? Int
                    else {
                        MsgDisplay.showErrorMsg("用户认证失败，请重新登陆试试")
                        return
                }
                
                MsgDisplay.dismiss()
                self.status = fooStatus
                self.version = fooVersion
                self.bikeToken = fooBikeToken
                self.expire = fooExpire
                
                /*
                NSUserDefaults.standardUserDefaults().setValue(fooBikeToken, forKey: "BicycleToken")
                NSUserDefaults.standardUserDefaults().setValue(fooStatus, forKey: "BicycleStatus")
                NSUserDefaults.standardUserDefaults().setValue(fooVersion, forKey: "BicycleVersion")
                NSUserDefaults.standardUserDefaults().setValue(fooExpire, forKey: "BicycleExpire")
                */
                
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
                //log.obj(dic!)/
                guard dic?.objectForKey("errno") as? NSNumber == 0 else {
                    MsgDisplay.showErrorMsg(dic?.objectForKey("errmsg") as? String)
                    return
                }
            
                MsgDisplay.dismiss()
                let list = dic?.objectForKey("data") as? NSArray

                self.cardList.removeAll()
                for dict in list! {
                    let cardInfo = dict as? NSDictionary
                    self.cardList.append(Card(dict: cardInfo!))
                }
                doSomething()
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                print("error: \(error)")
        })
    }
    
    func bindCard(id: String, sign: String, doSomething: () -> ()) {
        let parameters = ["auth_token": bikeToken!, "id": id, "sign": sign]
        
        let manager = AFHTTPSessionManager()
        
        manager.POST(BicycleAPIs.bindURL, parameters: parameters, progress: { (progress: NSProgress) in
            
            MsgDisplay.showLoading()
            
            }, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                
                let dic = responseObject as? NSDictionary
                //log.obj(dic!)/
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
                //log.obj(dic!)/
                guard dic?.objectForKey("errno") as? NSNumber == 0 else {
                    MsgDisplay.showErrorMsg(dic?.objectForKey("errmsg") as? String)
                    return
                }
                
                let dict = dic?.objectForKey("data") as? NSDictionary
                print(dict)
                
                
                guard let fooName = dict?.objectForKey("name") as? String,
                    let fooBalance = dict?.objectForKey("balance") as? String,
                    let fooDuration = dict?.objectForKey("duration") as? String,
                    let fooRecent = dict?.objectForKey("recent") as? Array<Array<AnyObject>>,
                    let fooRecord = dict?.objectForKey("record") as? NSDictionary
                    else {
                        MsgDisplay.showErrorMsg("获取用户数据失败，请重新登陆试试")
                        return
                }
 
                
                /*print(fooName)
                print(fooBalance)
                print(fooDuration)
                print(fooRecent)
                print(fooRecord)*/
                
                
                MsgDisplay.dismiss()
                
                self.name = fooName
                self.balance = fooBalance
                self.duration = fooDuration
                self.recent = fooRecent
                self.record = fooRecord
                
                doSomething()
                
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                print("error: \(error)")
        })
    }
    
}