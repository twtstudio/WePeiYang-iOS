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
    
    struct Banner {
        var image: String
        var title: String
        var url: String
    }
    
    struct RecommendedBook {
        var id: String
        var title: String
        var author: String
        var cover: String
    }
    
    struct StarUser {
        var id: String
        var name: String
        var avatar: String
        var reviewCount: String
    }
    
    struct Review {
        var bookId: String
        var username: String
        var avatar: String
        var score: Int
        var like: String
        var content: String
    }
    
    func getBannerList(success: () -> ()) {
        
//        bannerList = [
//            Banner(id: 1, image: "http://www.twt.edu.cn/upload/banners/hheZnqd196Te76SDF9Ww.png", title: "", url: ""),
//            Banner(id: 1, image: "http://www.twt.edu.cn/upload/banners/ZPQqmajzKOI3A6qE7gIR.png", title: "", url: ""),
//            Banner(id: 1, image: "http://www.twt.edu.cn/upload/banners/gJjWSlAvkGjZmdbuFtXT.jpeg", title: "", url: "")
//        ]
//        success()

        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue("Bearer {eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwiaXNzIjoiaHR0cDpcL1wvdGFrb29jdG9wdXMuY29tXC95dWVwZWl5YW5nXC9wdWJsaWNcL2FwaVwvYXV0aFwvdG9rZW5cL2dldCIsImlhdCI6MTQ3NzcyNjU1OCwiZXhwIjoxNDc4MzMxMzU4LCJuYmYiOjE0Nzc3MjY1NTgsImp0aSI6ImQwZDE0NTY3ZGUxNDk4OGI3YmVjNjRlNGI2Y2Y1ZjdlIn0.U1iM-nj4U-1r81gyI2gQgYi2R3B-0W-y5oUdSasD4o8}", forHTTPHeaderField: "Authorization")
        
        manager.GET(ReadAPI.bannerURL, parameters: nil, progress: nil, success: { (task, responseObject) in
            guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1,
                let data = dict["data"] as? Array<Dictionary<String, AnyObject>>
            else {
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
                self.bannerList.append(Banner(image: image, title: title, url: url))
            }
            success()
            
            }) { (_, error) in
                MsgDisplay.showErrorMsg("获取数据失败")
                print(error)
        }
    }
    
    func getRecommendedList(success: () -> ()) {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue("Bearer {eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwiaXNzIjoiaHR0cDpcL1wvdGFrb29jdG9wdXMuY29tXC95dWVwZWl5YW5nXC9wdWJsaWNcL2FwaVwvYXV0aFwvdG9rZW5cL2dldCIsImlhdCI6MTQ3NzcyNjU1OCwiZXhwIjoxNDc4MzMxMzU4LCJuYmYiOjE0Nzc3MjY1NTgsImp0aSI6ImQwZDE0NTY3ZGUxNDk4OGI3YmVjNjRlNGI2Y2Y1ZjdlIn0.U1iM-nj4U-1r81gyI2gQgYi2R3B-0W-y5oUdSasD4o8}", forHTTPHeaderField: "Authorization")
        
        manager.GET(ReadAPI.recomendedURL, parameters: nil, progress: nil, success: { (task, responseObject) in
            guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1,
            let data = dict["data"] as? Array<Dictionary<String, AnyObject>>
            else {
                MsgDisplay.showErrorMsg("获取数据失败")
                return
            }
            
            for dic in data {
                guard let id = dic["id"] as? String,
                let title = dic["title"] as? String,
                let author = dic["author"] as? String,
                let cover = dic["cover_url"] as? String
                else {
                    continue
                }
                
                self.recommendedList.append(RecommendedBook(id: id, title: title, author: author, cover: cover))
            }
            success()
            }) { (_, error) in
                MsgDisplay.showErrorMsg("获取数据失败")
                print(error)
        }
        
        //        recommendedList = [
        //            RecommendedBook(isbn: "", title: "从你的全世界路过", author: "张嘉佳", cover: "http://imgsrc.baidu.com/forum/w%3D580/sign=90a6b0a29f16fdfad86cc6e6848e8cea/fd1f4134970a304e1256eb73d3c8a786c8175cc6.jpg"),
        //            RecommendedBook(isbn: "", title: "雷雨", author: "曹禺", cover: "http://pic9.997788.com/pic_auction/00/08/13/58/au8135818.jpg"),
        //            RecommendedBook(isbn: "", title: "目送", author: "龙应台", cover: "http://img7.doubanio.com/lpic/s27222202.jpg"),
        //            RecommendedBook(isbn: "", title: "活着", author: "余华", cover: "http://www.sxdaily.com.cn/NMediaFile/2014/0512/SXRB201405120949000180440088541.jpg"),
        //            RecommendedBook(isbn: "", title: "野火集", author: "龙应台", cover: "https://img3.doubanio.com/lpic/s4390060.jpg")
        //        ]
    }
    
    func getStarUserList(success: () -> ()) {
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue("Bearer {eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwiaXNzIjoiaHR0cDpcL1wvdGFrb29jdG9wdXMuY29tXC95dWVwZWl5YW5nXC9wdWJsaWNcL2FwaVwvYXV0aFwvdG9rZW5cL2dldCIsImlhdCI6MTQ3NzcyNjU1OCwiZXhwIjoxNDc4MzMxMzU4LCJuYmYiOjE0Nzc3MjY1NTgsImp0aSI6ImQwZDE0NTY3ZGUxNDk4OGI3YmVjNjRlNGI2Y2Y1ZjdlIn0.U1iM-nj4U-1r81gyI2gQgYi2R3B-0W-y5oUdSasD4o8}", forHTTPHeaderField: "Authorization")
        
        manager.GET(ReadAPI.starUserURL, parameters: nil, progress: nil, success: { (task, responseObject) in
            guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1,
                let data = dict["data"] as? Array<Dictionary<String, AnyObject>>
                else {
                    MsgDisplay.showErrorMsg("获取数据失败")
                    return
            }
            
            for dic in data {
                guard let id = dic["twtid"] as? String,
                    let name = dic["twtuname"] as? String,
                    let avatar = dic["avatar"] as? String,
                    let reviewCount = dic["review_count"] as? String
                    else {
                        continue
                }
                
                self.starList.append(StarUser(id: id, name: name, avatar: avatar, reviewCount: reviewCount))
            }
            success()
        }) { (_, error) in
            MsgDisplay.showErrorMsg("获取数据失败")
            print(error)
        }
        
//        starList = [
//            StarUser(id: "1", name: "刘德华", avatar: "http://img.jiqie.com/z/0/5/1039_jiqie_com.jpg", reviewCount: 16),
//            StarUser(id: "1", name: "猫酱", avatar: "http://img5q.duitang.com/uploads/item/201505/13/20150513092503_f85Qm.thumb.224_0.jpeg", reviewCount: 6),
//            StarUser(id: "1", name: "佐助", avatar: "http://pic.wenwen.soso.com/p/20110604/20110604133102-376475389.jpg", reviewCount: 4),
//        ]
        
    }
    
    func getHotReviewList(success: () -> ()) {
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue("Bearer {eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0IiwiaXNzIjoiaHR0cDpcL1wvdGFrb29jdG9wdXMuY29tXC95dWVwZWl5YW5nXC9wdWJsaWNcL2FwaVwvYXV0aFwvdG9rZW5cL2dldCIsImlhdCI6MTQ3NzcyNjU1OCwiZXhwIjoxNDc4MzMxMzU4LCJuYmYiOjE0Nzc3MjY1NTgsImp0aSI6ImQwZDE0NTY3ZGUxNDk4OGI3YmVjNjRlNGI2Y2Y1ZjdlIn0.U1iM-nj4U-1r81gyI2gQgYi2R3B-0W-y5oUdSasD4o8}", forHTTPHeaderField: "Authorization")
        
        manager.GET(ReadAPI.hotReviewURL, parameters: nil, progress: nil, success: { (task, responseObject) in
            guard let dict = responseObject as? Dictionary<String, AnyObject> where dict["error_code"] as! Int == -1,
                let data = dict["data"] as? Array<Dictionary<String, AnyObject>>
                else {
                    MsgDisplay.showErrorMsg("获取数据失败")
                    return
            }
            
            for dic in data {
                guard let id = dic["book_id"] as? String,
                    let username = dic["user_name"] as? String,
                    let avatar = dic["avatar"] as? String,
                    //let score = dic["scores"] as? Int,
                    let like = dic["like"] as? String,
                    let content = dic["content"] as? String
                else {
                        continue
                }
                
                self.reviewList.append(Review(bookId: id, username: username, avatar: avatar, score: 5, like: like, content: content))
            }
            print(self.reviewList)
            success()
        }) { (_, error) in
            MsgDisplay.showErrorMsg("获取数据失败")
            print(error)
        }
        
    }
}