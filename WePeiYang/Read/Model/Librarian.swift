//
//  Librarian.swift
//  WePeiYang
//
//  Created by Allen X on 10/27/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//


class Librarian {
    
    struct SearchResult {
        let title: String
        //优化，此时得到的一些信息，特别是 cover 的图片可以在详情页面复用
        let coverURL: String
        let author: String
        let publisher: String
        let year: String
        let rating: Double
        let bookID: Int
        let ISBN: String
    }
    
    static let shared = Librarian()
//    static var resultList = [SearchResult]()
//    static var currentBook: Book? = nil
    
    static func searchBook(withString str: String, and completion: [SearchResult] -> ()) {
        
        User.sharedInstance.getToken {
            
            token in
//            log.word(token)/
            let manager = AFHTTPSessionManager()
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            var searchURL = ReadAPI.bookSearchURL + str
            searchURL = searchURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            log.word(searchURL)/
//            manager.GET(searchURL, parameters: nil, progress: { (_) in
//                MsgDisplay.showLoading()
//                }, success: { (task, responseObject) in
            MsgDisplay.showLoading()
            manager.GET(searchURL, parameters: nil, progress: nil, success: { (task, responseObject) in
               // print(responseObject)
                    guard responseObject != nil else {
                        MsgDisplay.showErrorMsg("哎呀，    出错啦")
                        //log.word("fuck1")/
                        return
                    }
                    
                    guard responseObject?.objectForKey("error_code") as? Int == -1 else {
                        guard let msg = responseObject?.objectForKey("message") as? String else {
                            MsgDisplay.showErrorMsg("未知错误1")
                            //log.word("fuck2")/
                            return
                        }
                        
                        MsgDisplay.showErrorMsg(msg)
                        //log.word("fuck1\(msg)")/
                        return
                    }
                    
                    guard let fooBooksResults = responseObject?.objectForKey("data") as? Array<NSDictionary> else {
                        completion([SearchResult]())
                        return
                    }
                    
                    let foo = fooBooksResults.flatMap({ (dict: NSDictionary) -> SearchResult? in
                        guard let title = dict["title"] as? String,
                            //let coverURL = dict["cover"] as? String,
                            let author = dict["author"] as? String,
                            let publisher = dict["publisher"] as? String,
                            let year = dict["year"] as? String,
                            //let rating = dict["rating"] as? Double,
                            let bookID = dict["index"] as? String,
                            let ISBN = dict["isbn"] as? String
                            else {
                                MsgDisplay.showErrorMsg("未知错误2")
                                log.word("未知错误")/
                                return nil
                        }
                        
                        var coverURL = "https://images-na.ssl-images-amazon.com/images/I/51w6QuPzCLL._SX319_BO1,204,203,200_.jpg"
                        if let foo = dict["cover"] as? String {
                            coverURL = foo
                        }
                        
                        var rating: Double = 3.0
                        if let foo = dict["rating"] as? Double {
                            rating = foo
                        }
                        // FIXME: bookID到底是String还是Int
                        return SearchResult(title: title, coverURL: coverURL, author: author, publisher: publisher, year: year, rating: rating, bookID: Int(bookID)!, ISBN: ISBN)
                    })
                    MsgDisplay.dismiss()
                    completion(foo)
                    
            }) { (_, err) in
                MsgDisplay.showErrorMsg("网络不好，请稍后重试")
                log.any(err)/
            }
        }
        
    }
    
    
    static func getBookDetail(ofID id: String, and completion: Book -> ()) {
        
        User.sharedInstance.getToken { token in
            let manager = AFHTTPSessionManager()
            //manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
            manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
            let bookDetailURL = ReadAPI.bookDetailURL + "\(id)?include=review,starreview,holding"
//            log.word(bookDetailURL)/
            manager.GET(bookDetailURL, parameters: nil, progress: { (_) in
                MsgDisplay.showLoading()
                }, success: { (task, responseObject) in
                 //   print(responseObject)
                    MsgDisplay.dismiss()
                    guard responseObject != nil else {
                        MsgDisplay.showErrorMsg("哎呀，出错啦")
                        //log.word("fuck1")/
                        return
                    }
                    
                    guard responseObject?.objectForKey("error_code") as? Int == -1 else {
                        guard let msg = responseObject?.objectForKey("message") as? String else {
                            MsgDisplay.showErrorMsg("未知错误")
                            return
                        }
                        
                        MsgDisplay.showErrorMsg(msg)
                        return
                    }
//                    log.obj(responseObject!)/
                    guard let fooDetail = responseObject?.objectForKey("data") as? NSDictionary else {
                        MsgDisplay.showErrorMsg("服务器开小差啦")
                        log.word("Server Fault1")/
                        //log.word("fuck3")/
                        return
                    }
                    
//                    log.obj(fooData)/
//                    
//                    guard let fooDetail = fooData["data"] as? NSDictionary else {
//                        MsgDisplay.showErrorMsg("服务器开小差啦")
//                        log.word("Server Fault2")/
//                        //log.word("fuck3")/
//                        return
//                    }
                    
                    guard let id = fooDetail["id"] as? Int,
                        let title = fooDetail["title"] as? String,
                        let ISBN = fooDetail["isbn"] as? String,
                        let author = fooDetail["author"] as? String,
                        let publisher = fooDetail["publisher"] as? String,
                        let year = fooDetail["time"] as? String,
                        //let coverURL = fooDetail["cover_url"] as? String,
                        //let rating = fooDetail["rating"] as? Double,
                        //let index = fooDetail["index"] as? String,
                        let reviewData = fooDetail["review"] as? NSDictionary,
                        let starReviewData = fooDetail["starreview"] as? NSDictionary,
                        let summary = fooDetail["summary"] as? String,
                        let holdingStatusData = fooDetail["holding"] as? NSDictionary else {
                            MsgDisplay.showErrorMsg("未知错误2")
                            log.word("Unknown Error2")/
                            return
                    }
                    
                    //Default cover
                    var coverURL = "https://images-na.ssl-images-amazon.com/images/I/51w6QuPzCLL._SX319_BO1,204,203,200_.jpg"
                    if let foo = fooDetail["cover_url"] as? String {
                        coverURL = foo
                    }
                    //Default rating
                    var rating = 3.0
                    if let foo = fooDetail["rating"] as? Double {
                        rating = foo
                    }
                    
                    var fooHoldingStatus: [Book.Status] = []
                    if let holdingStatus = holdingStatusData["data"] as? Array<NSDictionary> {
//                        log.obj(holdingStatus)/
                        fooHoldingStatus = holdingStatus.flatMap({ (dict: NSDictionary) -> Book.Status? in
                            guard let id = dict["id"] as? Int,
                                let barcode = dict["barcode"] as? String,
                                let callno = dict["callno"] as? String,
                                let stateCode = dict["stateCode"] as? Int,
                                let state = dict["state"] as? String,
                                let statusInLibrary = dict["state"] as? String,
                                let libCode = dict["libCode"] as? String,
                                let localCode = dict["localCode"] as? String,
                                let dueTime = dict["indate"] as? String,
                                let library = dict["local"] as? String
                            else {
                                    MsgDisplay.showErrorMsg("未知错误3")
                                    log.word("Unknown Error3")/
                                    return nil
                            }
                            //return nil
                            return Book.Status(id: id, barcode: barcode, callno: callno, stateCode: stateCode, statusInLibrary: statusInLibrary, libCode: libCode, localCode: localCode, dueTime: dueTime, library: library)
                        })

                    }
                    
                    var fooReviews: [Review] = []
                    if let reviews = reviewData["data"] as? Array<NSDictionary> {
                        
                        fooReviews = reviews.flatMap({ (dict: NSDictionary) -> Review? in
                            guard let reviewID = dict["review_id"] as? Int,
                                let bookID = dict["book_id"] as? Int,
                                let bookName = dict["title"] as? String,
                                let userName = dict["user_name"] as? String,
                                let avatarURL = dict["avatar"] as? String,
                                let rating = dict["score"] as? Double,
                                let like = dict["like_count"] as? Int,
                                let content = dict["content"] as? String,
                                let updateTime = dict["updated_at"] as? String,
                                //TODO: liked as Bool may fail
                                let liked = dict["liked"] as? Bool else {
                                    MsgDisplay.showErrorMsg("未知错误")
                                    log.word("Unknown Error5")/
                                    return nil
                            }
                            log.word(content)/
                            return Review(reviewID: reviewID, bookID: bookID, bookName: bookName, userName: userName, avatarURL: avatarURL, rating: rating, like: like, content: content, updateTime: updateTime, liked: liked)
                        })
                    }
                    
                    
                    var fooStarReviews: [StarReview] = []
                    
                    if let star_reviews = starReviewData["data"] as? Array<NSDictionary> {
                        fooStarReviews = star_reviews.flatMap({ (dict: NSDictionary) -> StarReview? in
                            guard let name = dict["name"] as? String,
                                let content = dict["content"] as? String else {
                                    return nil
                            }
                            return StarReview(name: name, content: content)
                        })
                    }
                    let foo = Book(id: id, title: title, ISBN: ISBN, author: author, publisher: publisher, year: year, coverURL: coverURL, rating: rating, summary: summary, status: fooHoldingStatus, reviews: fooReviews, starReviews: fooStarReviews)
                    log.obj(foo)/
                    completion(foo)
                    
            }) { (_, err) in
                MsgDisplay.showErrorMsg("网络不好，请稍后重试")
                log.any("fucker")/
            }
        }
        
    }
    
    
}

