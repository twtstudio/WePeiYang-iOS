//
//  ClasstableDataManager.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/28.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import AFNetworking

class ClasstableDataManager: NSObject {
    
    class func getClasstableData(success: (data: AnyObject, termStartTime: Int) -> (), notBinded: () -> (), otherFailure: (errorMsg: String) -> ()) {
        twtSDK.getClasstableWithToken(NSUserDefaults.standardUserDefaults().stringForKey(TOKEN_SAVE_KEY), success: {(task, responseObject) in
            let dic = responseObject as! Dictionary<String, AnyObject>
            if dic["error_code"] as! Int == -1 {
                if dic["data"] != nil {
                    success(data: (dic["data"]!).objectForKey("data")!, termStartTime: (dic["data"]!).objectForKey("term_start")! as! Int)
                } else {
                    otherFailure(errorMsg: dic["message"] as! String)
                }
            }
        }, failure: {(task, error) in
            let errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData
            do {
                let dic = try NSJSONSerialization.JSONObjectWithData(errorResponse, options: .MutableContainers)
                let errorCodeStr = dic["error_code"] as! String
                if errorCodeStr == "403" {
                    notBinded()
                } else {
                    otherFailure(errorMsg: dic["message"] as! String)
                }
            } catch {
                
            }
            
        })
    }

}
