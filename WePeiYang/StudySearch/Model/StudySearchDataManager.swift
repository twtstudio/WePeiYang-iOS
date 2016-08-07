//
//  StudySearchDataManager.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/6/18.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

let CLASSROOM_DATA_KEY = "CLASSROOM_DATA_KEY"

class StudySearchDataManager: NSObject {
    
    class func refreshClassroomsList(success: (listDic: [String: String]) -> (), failure: (errorMsg: String) -> ()) {
        twtSDK.getClassrooms({ (task, responseObject) in
            let jsonData = JSON(responseObject)
            if jsonData["error_code"].int == -1 {
                let dataArr: [JSON] = jsonData["data", "buildings"].arrayValue
                var dataDic: [String: String] = [:]
                for tmpJSON in dataArr {
                    dataDic[tmpJSON["id"].stringValue] = tmpJSON["name"].stringValue
                }
                wpyCacheManager.saveGroupCacheData(dataDic, withKey: CLASSROOM_DATA_KEY)
                success(listDic: dataDic)
            }
        }, failure: { (task, error) in
            if let errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData {
                let errorJSON = JSON(data: errorResponse)
                failure(errorMsg: errorJSON["message"].stringValue)
            } else {
                failure(errorMsg: error.localizedDescription)
            }
        })
    }
    
    class func getAvaliableClassroomsList(buildingId buildingId: Int, success: () -> (), failure: (errorMsg: String) -> ()) {
        twtSDK.getAvaliableClassroomsWithBuildingID(buildingId, success: { (task, responseObj) in
            let jsonData = JSON(responseObj)
            if jsonData["error_code"].int == -1 {
                let data = jsonData["data"]
                print("\(data)")
            }
        }, failure: { (task, error) in
            if let errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData {
                let errorJSON = JSON(data: errorResponse)
                failure(errorMsg: errorJSON["message"].stringValue)
            } else {
                failure(errorMsg: error.localizedDescription)
            }
        })
    }
    
}
