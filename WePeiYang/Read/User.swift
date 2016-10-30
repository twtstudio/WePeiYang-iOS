
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
    var reviewArr = [Review]() // 我的点评
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
//
//        let manager = AFHTTPSessionManager()
//        // TODO: Token
//        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "application/json")
//        
//        manager.GET(review_url, parameters: nil, progress: nil,
//                    success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
//                        
//                        if let dict = responseObject as? NSDictionary{
//                            let data = dict["data"] as! [NSDictionary]
//                            self.reviewArr.removeAll()
//                            for dic:NSDictionary in data{
//                                let review = Review(dic: dic)
//                                self.reviewArr.append(review)
//                            }
//                        }
//                        
//                    success()
//            },
//                    failure: { (task: NSURLSessionDataTask?, error: NSError) in
//                        print("error: \(error)")
//        })
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue("Bearer {eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwiaXNzIjoiaHR0cDpcL1wvdGFrb29jdG9wdXMuY29tXC95dWVwZWl5YW5nXC9wdWJsaWNcL2FwaVwvYXV0aFwvdG9rZW5cL2dldCIsImlhdCI6MTQ3NzcyNjU1OCwiZXhwIjoxNDc4MzMxMzU4LCJuYmYiOjE0Nzc3MjY1NTgsImp0aSI6ImQwZDE0NTY3ZGUxNDk4OGI3YmVjNjRlNGI2Y2Y1ZjdlIn0.U1iM-nj4U-1r81gyI2gQgYi2R3B-0W-y5oUdSasD4o8}", forHTTPHeaderField: "Authorization")
        var fooReviewList: [Review] = []
        manager.GET(ReadAPI.hotReviewURL, parameters: nil, progress: nil, success: { (task, responseObject) in
            guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1,
                let data = dict["data"] as? Array<Dictionary<String, AnyObject>>
                else {
                    MsgDisplay.showErrorMsg("获取热门评论数据失败")
                    return
            }
            
            print(dict)
            for dic in data {
                guard let id = dic["book_id"] as? String,
                    let title = dic["title"] as? String,
                    let username = dic["user_name"] as? String,
                    let avatar = dic["avatar"] as? String,
                    let score = dic["scores"] as? Double,
                    let like = dic["like"] as? String,
                    let content = dic["content"] as? String,
                    let updateTime = dic["update_at"] as? String
                    else {
                        continue
                }
                fooReviewList.append(Review(bookID: id, title: title, userName: username, avatarURL: avatar, rating: score, like: like, content: content, updateTime: updateTime))
                //self.reviewList.append(Review(bookId: id, username: username, avatar: avatar, score: 5, like: like, content: content))
            }
            self.reviewArr = fooReviewList
            success()
        }) { (_, error) in
            MsgDisplay.showErrorMsg("获取热门评论数据失败")
            print(error)
        }

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
                    let book: MyBook = MyBook()
                    book.initWithDict(dic)
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
