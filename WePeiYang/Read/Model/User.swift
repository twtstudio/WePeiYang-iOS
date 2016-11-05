
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
        getToken { token in
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")

            var fooReviewList: [Review] = []
            manager.GET(ReadAPI.reviewURL, parameters: nil, progress: nil, success: { (task, responseObject) in
                print(responseObject)
                guard let dict = responseObject as? NSDictionary where dict["error_code"] as! Int == -1,
                    let data = dict["data"] as? Array<NSDictionary>
                    else {
                        MsgDisplay.showErrorMsg("获取评论数据失败")
                        return
                }
                // print(dict)
                for dic in data {
                     guard let reviewID = dic["review_id"] as? Int,
                        let bookID = dic["book_id"] as? Int,
                        let title = dic["title"] as? String,
                        let username = dic["user_name"] as? String,
                        let avatar = dic["avatar"] as? String,
                        let score = dic["score"] as? Double,
                        let like = dic["like_count"] as? Int,
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
                MsgDisplay.showErrorMsg("获取评论数据失败")
                print(error)
            }
            
        }

    }
    
// MARK: 111
    func getBookShelf(success: Void -> Void) {
        getToken({ token in
            let manager = AFHTTPSessionManager()
            //manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")

            manager.GET(ReadAPI.bookshelfURL, parameters: nil, progress:  nil,
                success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                    // TODO: 判断
                    print(responseObject)
                    guard let dict = responseObject as? NSDictionary where dict["error_code"] as! Int == -1,
                        let data = dict["data"] as? Array<NSDictionary>
                        else {
                            MsgDisplay.showErrorMsg("获取收藏数据失败")
                            return
                        }
                        self.bookShelf.removeAll()
                        for dic in data{
                            guard let book_id = dic["book_id"] as? Int,
                            title = dic["title"] as? String,
                            author = dic["author"] as? String
                            else {
                                    continue
                            }
                            let book: MyBook = MyBook(title: title, author: author, id: book_id)
                            self.bookShelf.append(book)
                        }
                        success()
                }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                    //MsgDisplay.showErrorMsg("网络错误，请稍后再试")
                    print("error: \(error)")
            })
            
        })
    }

    
    func like(method: LikeBtnMethod, reviewID: String, success: Void -> Void) {
        switch method {
        case .Like:
            getToken{
                token in
                let manager = AFHTTPSessionManager()
                manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
                manager.GET(ReadAPI.addLikeURL+reviewID, parameters: nil, progress: nil, success: { (task, responseObject) in
                    guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1
                        else {
                            MsgDisplay.showErrorMsg("点赞失败")
                            return
                    }
                    
                    // 为了解决从”我的“界面点赞之后进入我的评论列表不刷新的问题
                    for review in self.reviewArr {
                        if "\(review.reviewID)" == reviewID {
                            review.like += 1
                            review.liked = true
                        }
                    }
                    success()
                    print("点赞成功")
                    // print(dict["message"])
                }) { (_, error) in
                    //MsgDisplay.showErrorMsg("网络开小差啦")
                    print(error)
                }
                
            }
        case .CancelLike:
            break
        }
        
        
    }
    
    func commitReview(with content: String?, bookid: String, rating: Double, success: Void -> Void) {
        print("committing")
        getToken { token in
            
            if let content = content {
                let dic = ["content": content, "id": bookid, "score": rating]
                let manager = AFHTTPSessionManager()
                manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
                manager.POST(ReadAPI.commitReviewURL, parameters: dic, progress: nil, success: { (task, responseObject) in
                    print(responseObject)
                    guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1
                        else {
                            MsgDisplay.showErrorMsg("评论提交失败")
                            return
                    }
                    print(dict["message"])
                    success()
                }) { (_, error) in
                    MsgDisplay.showErrorMsg("网络开小差啦")
                    print(error)
                }
            } else {  // 没有评论neirong
                let manager = AFHTTPSessionManager()
                let dic = ["id": bookid, "score": rating]
                manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
                manager.POST(ReadAPI.scoreURL, parameters: dic, progress: nil, success: { (task, responseObject) in
                    guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1
                        else {
                            MsgDisplay.showErrorMsg("提交失败")
                            return
                    }
                    print(dict)
                    success()
                }) { (_, error) in
                    MsgDisplay.showErrorMsg("网络开小差啦")
                    print(error)
                }
            }
        }
    }
    
    func addToFavourite(with id: String, success: Void -> Void) {
        getToken { token in
            let manager = AFHTTPSessionManager()
            
            let url = ReadAPI.addBookShelfURL + id
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            manager.GET(url, parameters: nil, progress: nil, success: { (task, responseObject) in
                guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1
                    else {
                        MsgDisplay.showErrorMsg("添加失败")
                        return
                }

                print(dict)
                success()
            }) { (_, error) in
                MsgDisplay.showErrorMsg("网络开小差啦")
                print(error)
            }

        }
    }
    
    func delFromFavourite(with id: String, success: Void -> Void) {
        getToken { token in
            let manager = AFHTTPSessionManager()
            print(token)
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            let url = ReadAPI.delBookShelfURL + id
            manager.GET(url, parameters: nil, progress: nil, success: { (task, responseObject) in
                guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1
                    else {
                        MsgDisplay.showErrorMsg("删除失败")
                        return
                }
                
                print(dict)
                success()
            }) { (_, error) in
                MsgDisplay.showErrorMsg("网络开小差啦")
                print(error)
            }

        }
    }
    
    
    func getToken(success: String -> Void) {
//        NSUserDefaults.standardUserDefaults().setObject("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyMSIsImlzcyI6Imh0dHA6XC9cL3Rha29vY3RvcHVzLmNvbVwveXVlcGVpeWFuZ1wvcHVibGljXC9hcGlcL2F1dGhcL3Rva2VuXC9nZXQiLCJpYXQiOjE0NzgwNjU1NzcsImV4cCI6MTQ3ODY3MDM3NywibmJmIjoxNDc4MDY1NTc3LCJqdGkiOiIwMzg3OGQxZWYxMWE4NWUyNjgyMjAwNWUxMTM5NzhhZCJ9.ukkYKKW5RX2Bs6ewrT-M7E8UUQ2IHP9j4FBuRRqjdsY", forKey: "readToken")
       // NSUserDefaults.standardUserDefaults().removeObjectForKey("readToken")
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
