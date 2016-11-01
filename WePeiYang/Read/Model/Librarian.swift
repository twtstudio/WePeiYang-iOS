//
//  Librarian.swift
//  WePeiYang
//
//  Created by Allen X on 10/27/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//


class Librarian {
    
    static let apiURL = "fucker"
    //static let token = User.shared.token
    static let token = "sdfsefsdf"
    struct SearchResult {
        let id: String
        let title: String
        //优化，此时得到的一些信息，特别是 cover 的图片可以在详情页面复用
        let coverURL: String
        let author: String
        let publisher: String
        let year: String
        let rating: Double
        let index: String
    }
    
    static let shared = Librarian()
    static var resultList = [SearchResult]()
    static var currentBook: Book? = nil
    
    static func searchBook(withString str: String, and completion: () -> ()) {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
        
        manager.GET(apiURL, parameters: nil, progress: { (_) in
            MsgDisplay.showLoading()
            }, success: { (task, responseObject) in
                
                MsgDisplay.dismiss()
                guard responseObject != nil else {
                    MsgDisplay.showErrorMsg("哎呀，出错啦")
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
                    MsgDisplay.showErrorMsg("服务器开小差啦")
                    //log.word("fuck3")/
                    return
                }
                
                resultList = fooBooksResults.flatMap({ (dict: NSDictionary) -> SearchResult? in
                    guard let id = dict["id"] as? String,
                        let title = dict["title"] as? String,
                        let coverURL = dict["cover"] as? String,
                        let author = dict["author"] as? String,
                        let publisher = dict["publisher"] as? String,
                        let year = dict["year"] as? String,
                        let rating = dict["rating"] as? Double,
                        let index = dict["index"] as? String else {
                            MsgDisplay.showErrorMsg("未知错误2")
                            return nil
                    }
                    
                    return SearchResult(id: id, title: title, coverURL: coverURL, author: author, publisher: publisher, year: year, rating: rating, index: index)
                })
                completion()
                
        }) { (_: NSURLSessionDataTask?, err: NSError) in
            MsgDisplay.showErrorMsg("网络不好，请稍后重试")
            //log.any(err)/
        }
    }
    
    
    static func getBookDetail(ofID id: String, and completion: () -> ()) {
        let manager = AFHTTPSessionManager()
        //manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        manager.requestSerializer.setValue("Bearer {\(token)}", forHTTPHeaderField: "Authorization")
        
        manager.GET(apiURL, parameters: nil, progress: { (_) in
            MsgDisplay.showLoading()
            }, success: { (task, responseObject) in
                
                MsgDisplay.dismiss()
                guard responseObject != nil else {
                    MsgDisplay.showErrorMsg("哎呀，出错啦")
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
                
                guard let fooDetail = responseObject?.objectForKey("data") as? NSDictionary else {
                    MsgDisplay.showErrorMsg("服务器开小差啦")
                    //log.word("fuck3")/
                    return
                }
                
                guard let id = fooDetail["id"] as? String,
                    let title = fooDetail["title"] as? String,
                    let ISBN = fooDetail["isbn"] as? String,                    
                    let author = fooDetail["author"] as? String,
                    let publisher = fooDetail["publisher"] as? String,
                    let year = fooDetail["year"] as? String,
                    let coverURL = fooDetail["cover"] as? String,
                    let rating = fooDetail["rating"] as? Double,
                    let index = fooDetail["index"] as? String,
                    let summary = fooDetail["summary"] as? String,
                    let status = fooDetail["status"] as? Array<NSDictionary>,
                    //let star_reviews = fooDetail["star_review"] as? Array<NSDictionary>,
                    let reviews = fooDetail["reviews"] as? NSDictionary else {
                        MsgDisplay.showErrorMsg("未知错误2")
                        return
                }
                
                let fooStatus = status.flatMap({ (dict: NSDictionary) -> Book.Status? in
                    guard let barcode = dict["barcode"] as? String,
                        let statusInLibrary = dict["status"] as? Bool,
                        let dueTime = dict["due_time"] as? Int,
                        let library = dict["library"] as? String,
                        let location = dict["status"] as? String
                        else {
                            MsgDisplay.showErrorMsg("未知错误3")
                            return nil
                    }
                    
                    return Book.Status(barcode: barcode, status: statusInLibrary, dueTime: dueTime, library: library, location: location)
                    
                })
                
                guard let reviewList = reviews["data"] as? Array<NSDictionary> else {
                    MsgDisplay.showErrorMsg("未知错误4")
                    return
                }
                
                let fooReviews = reviewList.flatMap({ (dict: NSDictionary) -> Review? in
                    guard let bookID = dict["book_id"] as? String,
                        let bookName = dict["book_name"] as? String,
                        let userName = dict["user_name"] as? String,
                        let avatarURL = dict["avatar"] as? String,
                        let rating = dict["scores"] as? Double,
                        let like = dict["like"] as? String,
                        let content = dict["content"] as? String,
                        let updateTime = dict["updated_time"] as? String else {
                            MsgDisplay.showErrorMsg("未知错误5")
                            return nil
                    }
                    return Review(bookID: bookID, bookName: bookName, userName: userName, avatarURL: avatarURL, rating: rating, like: like, content: content, updateTime: updateTime)
                })
                
                
                var fooStarReviews: [StarReview]? = nil
                
                if let star_reviews = fooDetail["star_review"] as? Array<NSDictionary> {
                    fooStarReviews = star_reviews.flatMap({ (dict: NSDictionary) -> StarReview? in
                        guard let name = dict["name"] as? String,
                            let content = dict["content"] as? String else {
                                return nil
                        }
                        return StarReview(name: name, content: content)
                    })
                }
                
                currentBook = Book(id: id, title: title, ISBN: ISBN, author: author, publisher: publisher, year: year, coverURL: coverURL, rating: rating, index: index, summary: summary, status: fooStatus, reviews: fooReviews, starReviews: fooStarReviews)
                
                completion()
                
        }) { (_: NSURLSessionDataTask?, err: NSError) in
            MsgDisplay.showErrorMsg("网络不好，请稍后重试")
            //log.any(err)/
        }
        
        
    }
    
    
}

