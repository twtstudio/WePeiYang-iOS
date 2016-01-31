//
//  HomeDataManager.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/8.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import AFNetworking
import MJExtension

class HomeDataManager: NSObject {
    
    class func getHomeDataWithClosure(closure: (caroselArr: [AnyObject], campusArr: [AnyObject], announcementArr: [AnyObject]) -> (), failure: (NSError, String) -> ()) {
        
        SolaSessionManager.solaSessionWithSessionType(.GET, URL: "/app/index", token: AccountManager.tokenExists() ? NSUserDefaults.standardUserDefaults().stringForKey(TOKEN_SAVE_KEY) : nil, parameters: nil, success: {(task, responseObject) in
            let dic = responseObject as! Dictionary<String, AnyObject>
            if (dic["error_code"] as! Int == -1) {
                let carouselData = (dic["data"])!["carousel"] as! [AnyObject]
                let carouselArr = NewsData.mj_objectArrayWithKeyValuesArray(carouselData) as [AnyObject]
                
                let campusData = (((dic["data"])!["news"]!!)["campus"]) as! [AnyObject]
                let campusArr = NewsData.mj_objectArrayWithKeyValuesArray(campusData) as [AnyObject]
                
                let announceData = (((dic["data"])!["news"]!!)["annoucements"]) as! [AnyObject]
                let announceArr = NewsData.mj_objectArrayWithKeyValuesArray(announceData) as [AnyObject]
                
                closure(caroselArr: carouselArr, campusArr: campusArr, announcementArr: announceArr)
            }
            }, failure: {(task, error) in
                failure(error, error.localizedDescription)
        })
    }

}
