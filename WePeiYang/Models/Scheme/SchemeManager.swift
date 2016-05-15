//
//  SchemeManager.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/4/19.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class SchemeManager: NSObject {
    
    class func handleURL(url: NSURL) -> Bool {
        
        if url.scheme == "wepeiyang" {
            if url.host == "platform" {
                
                if url.path == "/startapp" {
                    var queryDic: [String: String] = [:]
                    if let urlComponents = url.query?.componentsSeparatedByString("&") {
                        for keyValuePair in urlComponents {
                            let pairComponents = keyValuePair.componentsSeparatedByString("=")
                            if let key = pairComponents.first?.stringByRemovingPercentEncoding {
                                if let value = pairComponents.last?.stringByRemovingPercentEncoding {
                                    queryDic[key] = value
                                }
                            }
                        }
                    }
                    
                    if queryDic["app"] != nil {
                        switch queryDic["app"]! {
                        case "h5":
                            if queryDic["url"] != nil {
                                let url = queryDic["url"]
                                let webViewController = wpyModalWebViewController(address: url!)
                                SolaFoundationKit.topViewController().presentViewController(webViewController, animated: true, completion: nil)
                            }
                        case "main":
                            break
                        case "gpa":
                            break
                        case "classtable":
                            break
                        default:
                            break
                        }
                    }
                }
            }
            
            
            return true
        } else {
            return false
        }
    }
    
}
