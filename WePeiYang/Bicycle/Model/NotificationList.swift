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
    var newestTimeStamp: NSNumber = 0
    
    static let sharedInstance = NotificationList()
    private override init() {}
    
    func getList(doSomething: () -> ()) {
        
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