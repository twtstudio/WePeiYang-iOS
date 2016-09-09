//
//  ClasstableDataManager.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/28.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON

class ClasstableDataManager: NSObject {
    
    class func getClasstableData(success: (data: AnyObject, termStartTime: Int) -> (), notBinded: () -> (), otherFailure: (errorMsg: String) -> ()) {
        twtSDK.getClasstableWithToken(NSUserDefaults.standardUserDefaults().stringForKey(TOKEN_SAVE_KEY), success: {(task, responseObject) in
            let dic = JSON(responseObject)
            if dic["error_code"].int == -1 {
                if dic["data", "data"] != nil && dic["data", "term_start"] != nil {
                    success(data: dic["data", "data"].object, termStartTime: dic["data", "term_start"].intValue)
                } else {
                    if dic["message"].stringValue != "" {
                        otherFailure(errorMsg: dic["message"].stringValue)
                    } else {
                        otherFailure(errorMsg: "服务器开小差了😘")
                    }
                }
            }
        }, failure: {(task, error) in
            if let errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData {
                let errorJSON = JSON(data: errorResponse)
                if errorJSON["error_code"].int == 20001 {
                    notBinded()
                } else {
                    otherFailure(errorMsg: errorJSON["message"].stringValue)
                }
            } else {
                otherFailure(errorMsg: error.localizedDescription)
            }
        })
    }

}
