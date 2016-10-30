
//
//  User.swift
//  YuePeiYang
//
//  Created by Halcao on 2016/10/26.
//  Copyright © 2016年 Halcao. All rights reserved.
//

import UIKit
import AFNetworking

class User: NSObject {
    var username: String!
    var bookShelf = [MyBook]() // 我的收藏
    var reviewArr = [MyReview]() // 我的点评
    var avatar: String! // 头像url
    var id: Int!
    
    let review_url = "http://162.243.136.96/review.json"
    let bookshelf_url = "http://162.243.136.96/bookshelf.json"

    private static let instance = User()
    private override init() {}
    static var sharedInstance: User{
        return self.instance
    }
    
    func getReviewArr(success: Void -> Void) {
    //    guard let token = NSUserDefaults.standardUserDefaults().objectForKey("twtToken") else {
           // MsgDisplay.showErrorMsg("你需要登录才能访问党建功能")
           // let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
          //  UIViewController.currentViewController().presentViewController(loginVC, animated: true, completion: nil)
         //   return
        //}

        let manager = AFHTTPSessionManager()
        // TODO: Token
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "application/json")
        
        manager.GET(review_url, parameters: nil, progress: nil,
                    success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                        
                        if let dict = responseObject as? NSDictionary{
                            let data = dict["data"] as! [NSDictionary]
                            self.reviewArr.removeAll()
                            for dic:NSDictionary in data{
                                let review = MyReview(dic: dic)
                                self.reviewArr.append(review)
                            }
                        }
                        
                    success()
            },
                    failure: { (task: NSURLSessionDataTask?, error: NSError) in
                        print("error: \(error)")
        })
    }
    
    func getBookShelf(success: Void -> Void) {
        //guard let token = NSUserDefaults.standardUserDefaults().objectForKey("twtToken") else {
            // MsgDisplay.showErrorMsg("你需要登录才能访问党建功能")
            // let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            //  UIViewController.currentViewController().presentViewController(loginVC, animated: true, completion: nil)
//            return
//        }
        
      //  let parameters = ["token": token]
        let manager = AFHTTPSessionManager()
        
        // 参数
        manager.GET(bookshelf_url, parameters: nil, progress:  nil,
                    success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            // TODO: 判断
            if let dict = responseObject as? NSDictionary{
                let data = dict["data"] as! [NSDictionary]
                self.bookShelf.removeAll()
                for dic:NSDictionary in data{
                    let book: MyBook = MyBook(dic: dic)
                    self.bookShelf.append(book)
                }
            }
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                //MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                print("error: \(error)")
        })
    }
    
}

//func like(review: MyReview, success: Void -> Void) {
//    success()
//}
