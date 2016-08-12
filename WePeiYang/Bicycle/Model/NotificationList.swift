//
//  NotificationList.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/10.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class NotificationList: NSObject {
    
    var list: Array<NotificationItem> = []
    var newestTimeStamp: Int = 0
    var didGetNewNotification: Bool = false
    
    static let sharedInstance = NotificationList()
    private override init() {}
    
    func getList(doSomething: () -> ()) {
        
        list.removeAll()
        
        let manager = AFHTTPSessionManager()
        manager.GET(BicycleAPIs.notificationURL(), parameters: nil, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                
            let dic = responseObject as? NSDictionary
            log.obj(dic!)/
            
            guard dic?.objectForKey("errno") as? NSNumber == 0 else {
                MsgDisplay.showErrorMsg(dic?.objectForKey("errmsg") as? String)
                return
            }
            
            guard let foo = dic?.objectForKey("data") as? NSArray else {
                MsgDisplay.showErrorMsg("获取信息失败")
                return
            }
            
            if foo.count > 0 {
                let fooTimeStamp = Int(foo[0].objectForKey("timestamp") as! String)!
                if fooTimeStamp > self.newestTimeStamp {
                    self.didGetNewNotification = true
                    self.newestTimeStamp = fooTimeStamp
                }
            }
            
            for dict in foo {
                self.list.append(NotificationItem(dict: dict as! NSDictionary))
            }
            
            doSomething()
                
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            MsgDisplay.showErrorMsg("网络错误，请稍后再试")
            print("error: \(error)")
        })
    }
    
}