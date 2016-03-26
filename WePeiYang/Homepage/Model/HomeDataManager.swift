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

let HOME_CACHE_DATA_KEY = "HOME_CACHE_DATA_KEY"

class HomeDataManager: NSObject {
    
    class func getHomeDataWithClosure(closure: (isCached: Bool, caroselArr: [AnyObject], campusArr: [AnyObject], announcementArr: [AnyObject]) -> (), failure: (NSError, String) -> ()) {
        
        wpyCacheManager.loadCacheDataWithKey(HOME_CACHE_DATA_KEY, andBlock: {data in
            let dic = JSON(data)
            if dic["error_code"].int == -1 {
                let carouselData = dic["data", "carousel"].arrayObject
                let carouselArr = NewsData.mj_objectArrayWithKeyValuesArray(carouselData) as [AnyObject]
                
                let campusData = dic["data", "news", "campus"].arrayObject
                let campusArr = NewsData.mj_objectArrayWithKeyValuesArray(campusData) as [AnyObject]
                
                let announceData = dic["data", "news", "annoucements"].arrayObject
                let announceArr = NewsData.mj_objectArrayWithKeyValuesArray(announceData) as [AnyObject]
                
                closure(isCached: true, caroselArr: carouselArr, campusArr: campusArr, announcementArr: announceArr)
            }
        }, failed: nil)
        
        SolaSessionManager.solaSessionWithSessionType(.GET, URL: "/app/index", token: AccountManager.tokenExists() ? NSUserDefaults.standardUserDefaults().stringForKey(TOKEN_SAVE_KEY) : nil, parameters: nil, success: {(task, responseObject) in
            
            wpyCacheManager.saveCacheData(responseObject, withKey: HOME_CACHE_DATA_KEY)
            
            let dic = JSON(responseObject)
            if dic["error_code"].int == -1 {
                let carouselData = dic["data", "carousel"].arrayObject
                let carouselArr = NewsData.mj_objectArrayWithKeyValuesArray(carouselData) as [AnyObject]
                
                let campusData = dic["data", "news", "campus"].arrayObject
                let campusArr = NewsData.mj_objectArrayWithKeyValuesArray(campusData) as [AnyObject]
                
                let announceData = dic["data", "news", "annoucements"].arrayObject
                let announceArr = NewsData.mj_objectArrayWithKeyValuesArray(announceData) as [AnyObject]
                
                print("Home Data Refreshed")
                closure(isCached: false, caroselArr: carouselArr, campusArr: campusArr, announcementArr: announceArr)
            }

            }, failure: {(task, error) in
                failure(error, error.localizedDescription)
        })
    }

}
