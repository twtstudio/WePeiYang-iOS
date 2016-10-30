
//
//  User.swift
//  YuePeiYang
//
//  Created by Halcao on 2016/10/26.
//  Copyright © 2016年 Halcao. All rights reserved.
//
// 点赞 评论 收藏


import UIKit
import AFNetworking

enum LikeBtnMethod {
    case Like
    case CancelLike
}


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
        getToken({ make in
            let manager = AFHTTPSessionManager()
            manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "application/json")
            manager.GET(self.review_url, parameters: nil, progress: nil,
                success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                    
                    if let dict = responseObject as? NSDictionary{
                        let data = dict["data"] as! [NSDictionary]
                        self.reviewArr.removeAll()
                        for dic:NSDictionary in data{
                            // TODO: review initalize
                            let review = MyReview(dic: dic)
                            self.reviewArr.append(review)
                        }
                    }
                    success()
                },
                failure: { (task: NSURLSessionDataTask?, error: NSError) in
                    print("error: \(error)")
            })
            
        })
    }
    
    func getBookShelf(success: Void -> Void) {
        getToken({ token in
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            manager.GET(self.bookshelf_url, parameters: nil, progress:  nil,
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
            
        })
    }
    
    func like(method: LikeBtnMethod, success: Void -> Void) {
        getToken({ token in
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            
            switch method {
            case .Like:
                break
            case .CancelLike:
                break
            }
        })
        
    }
    
    func commitReview(review: Review, success: Void -> Void) {
        getToken({ token in
            
        })
    }
    
    func addToFavourite(success: Void -> Void) {
        getToken({ token in
            
        })
    }
    
    
    func getToken(success: String -> Void){
        guard let token = NSUserDefaults.standardUserDefaults().objectForKey("twtToken") else {
            MsgDisplay.showErrorMsg("你需要登录才能访问")
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            UIViewController.currentViewController().presentViewController(loginVC, animated: true, completion: nil)
            return
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("readToken") == nil {
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            manager.GET("heiheihei", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                //
                let readToken = ""
                NSUserDefaults.standardUserDefaults().setObject(readToken, forKey: "readToken")
                success(readToken)
                }, failure: { (_, error) in
                    log.error(error)/
                    MsgDisplay.showErrorMsg("There is something wrong with you")
            })
        }
        if let readToken = NSUserDefaults.standardUserDefaults().objectForKey("readToken") as? String {
            success(readToken)
        }
    }
    
}
