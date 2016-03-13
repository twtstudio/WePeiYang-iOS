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
import SwiftyJSON

class HomeDataManager: NSObject {
    
    class func getHomeDataWithClosure(closure: (caroselArr: [AnyObject], campusArr: [AnyObject], announcementArr: [AnyObject]) -> (), failure: (NSError, String) -> ()) {
        
        SolaSessionManager.solaSessionWithSessionType(.GET, URL: "/app/index", token: AccountManager.tokenExists() ? NSUserDefaults.standardUserDefaults().stringForKey(TOKEN_SAVE_KEY) : nil, parameters: nil, success: {(task, responseObject) in
            
            let dic = JSON(responseObject)
            if dic["error_code"].int == -1 {
                let carouselData = dic["data", "carousel"].arrayObject
                let carouselArr = NewsData.mj_objectArrayWithKeyValuesArray(carouselData) as [AnyObject]
                
                let campusData = dic["data", "news", "campus"].arrayObject
                let campusArr = NewsData.mj_objectArrayWithKeyValuesArray(campusData) as [AnyObject]
                
                let announceData = dic["data", "news", "annoucements"].arrayObject
                let announceArr = NewsData.mj_objectArrayWithKeyValuesArray(announceData) as [AnyObject]
                
                closure(caroselArr: carouselArr, campusArr: campusArr, announcementArr: announceArr)
            }

            }, failure: {(task, error) in
                failure(error, error.localizedDescription)
        })
    }

}
