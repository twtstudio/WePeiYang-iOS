//
//  Recommender.swift
//  WePeiYang
//
//  Created by JinHongxu on 2016/10/28.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

class Recommender {
    
    var bannerList: [Banner] = []
    var recommendedList: [RecommendedBook] = []
    var starList: [StarUser] = []
    var reviewList: [Review] = []
    var finishFlag = FinishFlag()
    var dataDidRefresh = false
    
    static let sharedInstance = Recommender()
    private init() {}
    
    struct Banner {
        var image: String
        var title: String
        var url: String
    }
    
    struct RecommendedBook {
        var id: Int
        var title: String
        var author: String
        var cover: String
    }
    
    struct StarUser {
        var id: Int
        var name: String
        var avatar: String
        var reviewCount: String
    }
    
    struct FinishFlag {
        var bannerFlag = false
        var recommendedFlag = false
        var hotReviewFlag = false
        var starUserFlag = false
        
        func isFinished() -> Bool {
            return bannerFlag && recommendedFlag && hotReviewFlag && starUserFlag
        }
        
        mutating func reset() {
            bannerFlag = false
            recommendedFlag = false
            hotReviewFlag = false
            starUserFlag = false
        }
    }
    
    func getBannerList(success: () -> ()) {
        
//        bannerList = [
//            Banner(id: 1, image: "http://www.twt.edu.cn/upload/banners/hheZnqd196Te76SDF9Ww.png", title: "", url: ""),
//            Banner(id: 1, image: "http://www.twt.edu.cn/upload/banners/ZPQqmajzKOI3A6qE7gIR.png", title: "", url: ""),
//            Banner(id: 1, image: "http://www.twt.edu.cn/upload/banners/gJjWSlAvkGjZmdbuFtXT.jpeg", title: "", url: "")
//        ]
//        success()

        User.sharedInstance.getToken({
            token in
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            
            var fooBannerList: [Banner] = []
            manager.GET(ReadAPI.bannerURL, parameters: nil, progress: nil, success: { (task, responseObject) in
//                print("banner")
//                print(responseObject)
                guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1,
                    let data = dict["data"] as? Array<Dictionary<String, AnyObject>>
                    else {
                        if let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == 10000 {
                            print("removed read token")
                            NSUserDefaults.standardUserDefaults().removeObjectForKey("readToken")
                        }
                        MsgDisplay.showErrorMsg("获取数据失败")
                        return
                }
                
                for dic in data {
                    guard let image = dic["img"] as? String,
                        let title = dic["title"] as? String,
                        let url = dic["url"] as? String
                        else {
                            continue
                    }
                    fooBannerList.append(Banner(image: image, title: title, url: url))
                    //self.bannerList.append(Banner(image: image, title: title, url: url))
                }
                self.finishFlag.bannerFlag = true
                self.bannerList = fooBannerList
                success()
                
            }) { (_, error) in
                self.finishFlag.bannerFlag = true
                MsgDisplay.showErrorMsg("获取 banner 数据失败")
                print(error)
            }
            
        })
        
    }
    
    func getRecommendedList(success: () -> ()) {
        User.sharedInstance.getToken({
            token in
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            var fooRecommendedList: [RecommendedBook] = []
            manager.GET(ReadAPI.recommendedURL, parameters: nil, progress: nil, success: { (task, responseObject) in
//                print("recommended")
//                print(responseObject)
                guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1,
                    let data = dict["data"] as? Array<Dictionary<String, AnyObject>>
                    else {
                        if let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == 10000 {
                            print("removed read token")
                            NSUserDefaults.standardUserDefaults().removeObjectForKey("readToken")
                        }
                        MsgDisplay.showErrorMsg("获取热门推荐数据失败")
                        return
                }
                
                for dic in data {
                    guard let id = dic["id"] as? Int,
                        let title = dic["title"] as? String,
                        let author = dic["author"] as? String,
                        let cover = dic["cover_url"] as? String
                        else {
                            continue
                    }
                    fooRecommendedList.append(RecommendedBook(id: id, title: title, author: author, cover: cover))
                    //self.recommendedList.append(RecommendedBook(id: id, title: title, author: author, cover: cover))
                }
                self.finishFlag.recommendedFlag = true
                self.recommendedList = fooRecommendedList
                success()
            }) { (_, error) in
                self.finishFlag.recommendedFlag = true
                MsgDisplay.showErrorMsg("获取热门推荐数据失败")
                print(error)
            }
        })
        
        
        //        recommendedList = [
        //            RecommendedBook(isbn: "", title: "从你的全世界路过", author: "张嘉佳", cover: "http://imgsrc.baidu.com/forum/w%3D580/sign=90a6b0a29f16fdfad86cc6e6848e8cea/fd1f4134970a304e1256eb73d3c8a786c8175cc6.jpg"),
        //            RecommendedBook(isbn: "", title: "雷雨", author: "曹禺", cover: "http://pic9.997788.com/pic_auction/00/08/13/58/au8135818.jpg"),
        //            RecommendedBook(isbn: "", title: "目送", author: "龙应台", cover: "http://img7.doubanio.com/lpic/s27222202.jpg"),
        //            RecommendedBook(isbn: "", title: "活着", author: "余华", cover: "http://www.sxdaily.com.cn/NMediaFile/2014/0512/SXRB201405120949000180440088541.jpg"),
        //            RecommendedBook(isbn: "", title: "野火集", author: "龙应台", cover: "https://img3.doubanio.com/lpic/s4390060.jpg")
        //        ]
    }
    
    func getStarUserList(success: () -> ()) {
        User.sharedInstance.getToken({
            token in
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            var fooStarList: [StarUser] = []
            manager.GET(ReadAPI.starUserURL, parameters: nil, progress: nil, success: { (task, responseObject) in
//                print("staruser")
//                print(responseObject)
                guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1,
                    let data = dict["data"] as? Array<Dictionary<String, AnyObject>>
                    else {
                        if let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == 10000 {
                            print("removed read token")
                            NSUserDefaults.standardUserDefaults().removeObjectForKey("readToken")
                        }
                        MsgDisplay.showErrorMsg("获取阅读之星数据失败")
                        return
                }
                
                for dic in data {
                    guard let id = dic["twtid"] as? Int,
                        let name = dic["twtuname"] as? String,
                        let avatar = dic["avatar"] as? String,
                        let reviewCount = dic["review_count"] as? String
                        else {
                            continue
                    }
                    fooStarList.append(StarUser(id: id, name: name, avatar: avatar, reviewCount: reviewCount))
                    //self.starList.append(StarUser(id: id, name: name, avatar: avatar, reviewCount: reviewCount))
                    
                }
                self.finishFlag.starUserFlag = true
                self.starList = fooStarList
                success()
            }) { (_, error) in
                self.finishFlag.starUserFlag = true
                MsgDisplay.showErrorMsg("获取阅读之星数据失败")
                print(error)
            }
        })
        
        
//        starList = [
//            StarUser(id: "1", name: "刘德华", avatar: "http://img.jiqie.com/z/0/5/1039_jiqie_com.jpg", reviewCount: 16),
//            StarUser(id: "1", name: "猫酱", avatar: "http://img5q.duitang.com/uploads/item/201505/13/20150513092503_f85Qm.thumb.224_0.jpeg", reviewCount: 6),
//            StarUser(id: "1", name: "佐助", avatar: "http://pic.wenwen.soso.com/p/20110604/20110604133102-376475389.jpg", reviewCount: 4),
//        ]
        
    }
    
    func getHotReviewList(success: () -> ()) {
        User.sharedInstance.getToken({
            token in
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            var fooReviewList: [Review] = []
            manager.GET(ReadAPI.hotReviewURL, parameters: nil, progress: nil, success: { (task, responseObject) in
//                print("hotreview")
//                print(responseObject)
                guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1,
                    let data = dict["data"] as? Array<Dictionary<String, AnyObject>>
                    else {
                        if let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == 10000 {
                            print("removed read token")
                            NSUserDefaults.standardUserDefaults().removeObjectForKey("readToken")
                        }
                        MsgDisplay.showErrorMsg("获取热门评论数据失败")
                        return
                }
                
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
                self.finishFlag.hotReviewFlag = true
                self.reviewList = fooReviewList
                //print(self.reviewList)
                success()
            }) { (_, error) in
                self.finishFlag.hotReviewFlag = true
                MsgDisplay.showErrorMsg("获取热门评论数据失败")
                print(error)
            }
        })
        
        
    }
}