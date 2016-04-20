//
//  LibraryDataManager.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/4/20.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON

class LibraryDataManager: NSObject {
    
    class func searchLibrary(keyword: String, page: Int, success: (data: [LibraryDataItem]) -> (), failure: (errorMsg: String) -> ()) {
        twtSDK.getLibrarySearchResultWithTitle(keyword, page: page, success: { (task, responseObject) in
            let jsonData = JSON(responseObject)
            if jsonData["error_code"].intValue == -1 {
                if let data = Mapper<LibraryDataItem>().mapArray(jsonData["data"].arrayObject) {
                    success(data: data)
                }
            }
        }, failure: { (task, error) in
            failure(errorMsg: error.localizedDescription)
        })
    }

}
