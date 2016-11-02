
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
    var bookShelf = [Book]() // 我的收藏
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
        
        getToken({ token in
//            let manager = AFHTTPSessionManager()
//            manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "application/json")
//            manager.GET(self.review_url, parameters: nil, progress: nil,
//                success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
//                    
//                    if let dict = responseObject as? NSDictionary{
//                        let data = dict["data"] as! [NSDictionary]
//                        self.reviewArr.removeAll()
//                        for dic:NSDictionary in data{
//                            // TODO: review initalize
//                            let review = MyReview(dic: dic)
//                            self.reviewArr.append(review)
//                        }
//                    }
//                    success()
//                },
//                failure: { (task: NSURLSessionDataTask?, error: NSError) in
//                    print("error: \(error)")
//            })
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue("Bearer {eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwiaXNzIjoiaHR0cDpcL1wvdGFrb29jdG9wdXMuY29tXC95dWVwZWl5YW5nXC9wdWJsaWNcL2FwaVwvYXV0aFwvdG9rZW5cL2dldCIsImlhdCI6MTQ3NzY2MjA4MywiZXhwIjoxNDc4MjY2ODgzLCJuYmYiOjE0Nzc2NjIwODMsImp0aSI6IjUzNTY5MTQ2MDhhOWE4YTBlYjdkYzJlNjllNWY4NWRkIn0.AS-dEMVQ909-L02f6syeUrsYiWWtoA_apOPemhZoOaQ}", forHTTPHeaderField: "Authorization")
            var fooReviewList: [Review] = []
            manager.GET(ReadAPI.reviewURL, parameters: nil, progress: nil, success: { (task, responseObject) in
                guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1,
                    let data = dict["data"] as? Array<Dictionary<String, AnyObject>>
                    else {
                        MsgDisplay.showErrorMsg("获取热门评论数据失败")
                        return
                }
                for dic in data {
                    guard let reviewID = dic["review_id"] as? String,
                        let bookID = dic["book_id"] as? String,
                        let title = dic["title"] as? String,
                        let username = dic["user_name"] as? String,
                        let avatar = dic["avatar"] as? String,
                        let score = dic["scores"] as? Double,
                        let like = dic["like_count"] as? String,
                        let content = dic["content"] as? String,
                        let updateTime = dic["updated_at"] as? String,
                        let liked = dic["liked"] as? Bool
                        else {
                            continue
                    }
                    fooReviewList.append(Review(reviewID: reviewID, bookID: bookID, bookName: title, userName: username, avatarURL: avatar, rating: score, like: like, content: content, updateTime: updateTime, liked: liked))
                    //self.reviewList.append(Review(bookId: id, username: username, avatar: avatar, score: 5, like: like, content: content))
                }
                self.reviewArr = fooReviewList
                success()
            }) { (_, error) in
                MsgDisplay.showErrorMsg("获取热门评论数据失败")
                print(error)
            }
            
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
                        for dic: NSDictionary in data{
                            let book: Book = Book(ISBN: "fsfd")
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

    
    func like(method: LikeBtnMethod, reviewID: String) {
//        getToken({ token in
//            let manager = AFHTTPSessionManager()
//            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
//            
//            switch method {
//            case .Like:
//                break
//            case .CancelLike:
//                break
//            }
//        })
        switch method {
        case .Like:
            getToken({
                token in
                let manager = AFHTTPSessionManager()
                manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
                manager.GET(ReadAPI.addLikeURL+reviewID, parameters: nil, progress: nil, success: { (task, responseObject) in
                    guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1
                        else {
                            MsgDisplay.showErrorMsg("点赞失败")
                            return
                    }
                    print(dict["message"])
                }) { (_, error) in
                    //MsgDisplay.showErrorMsg("网络开小差啦")
                    print(error)
                }
                
            })
        case .CancelLike:
            break
        }
        
        
    }
    
    func commitReview(review: Review, success: Void -> Void) {
        getToken({ token in
            
        })
    }
    
    func addToFavourite(success: Void -> Void) {
        getToken({ token in
            
        })
    }
    
    
    func getToken(success: String -> Void) {
//        NSUserDefaults.standardUserDefaults().setObject("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyMSIsImlzcyI6Imh0dHA6XC9cL3Rha29vY3RvcHVzLmNvbVwveXVlcGVpeWFuZ1wvcHVibGljXC9hcGlcL2F1dGhcL3Rva2VuXC9nZXQiLCJpYXQiOjE0NzgwNjU1NzcsImV4cCI6MTQ3ODY3MDM3NywibmJmIjoxNDc4MDY1NTc3LCJqdGkiOiIwMzg3OGQxZWYxMWE4NWUyNjgyMjAwNWUxMTM5NzhhZCJ9.ukkYKKW5RX2Bs6ewrT-M7E8UUQ2IHP9j4FBuRRqjdsY", forKey: "readToken")
        guard let token = NSUserDefaults.standardUserDefaults().objectForKey("twtToken") else {
            MsgDisplay.showErrorMsg("你需要登录才能访问")
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            UIViewController.currentViewController().presentViewController(loginVC, animated: true, completion: nil)
            return
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("readToken") == nil {
            let manager = AFHTTPSessionManager()
//            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            manager.GET(ReadAPI.tokenURL+"?wpy_token=\(token)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                //
                guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1,
                    let data = dict["data"] as? Dictionary<String, AnyObject>,
                    let readToken = data["token"] as? String
                    else {
                        MsgDisplay.showErrorMsg("身份认证失败")
                        return
                }
                
                NSUserDefaults.standardUserDefaults().setObject(readToken, forKey: "readToken")
                success(readToken)
                }, failure: { (_, error) in
                    log.error(error)/
                    MsgDisplay.showErrorMsg("身份认证失败")
            })
        }
        if let readToken = NSUserDefaults.standardUserDefaults().objectForKey("readToken") as? String {
            success(readToken)
        }
        
    }
    
}
