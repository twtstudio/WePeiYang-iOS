//
//  Courses.swift
//  WePeiYang
//
//  Created by Allen X on 8/5/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//



//两种课程：
struct Courses {
    
    //MARK: 20 课学习资料
    struct Study20 {
        
        static var courses: [Study20Course?] = []
        
        //MARK: 待整顿
        struct ScoreInfo{
            let id: String?
            let student_id: String?
            let course_id: String?
            let score: String?
            let complete_time: NSDate?
            let is_systemadd: Bool?
            let isdeleted: Bool?
            let course_name: String?
            let course_detail: String?
            let course_priority: String?
            let course_inserttime: NSDate?
            let course_ishidden: Bool?
            let course_isdeleted: Bool?
        }

        
        //MARK: 20 课学习资料摘要
        struct Study20Course {
            let courseID: String
            let courseName: String
            
            var courseDetails: [Study20Course.Detail?] = []
            var courseScore: Int?
            
            
            //MARK: 20 课学习资料详情
            struct Detail {
                let courseID: String?
                let courseName: String?
                let articleID: String?
                let articleName: String?
                let articleContent: String?
                let articleIsHidden: Bool?
                let articleIsDeleted: Bool?
                //types!!
                let coursePriority: String?
                let courseDetail: String?
                let courseInsertTime: NSDate?
                let courseIsHidden: Bool?
                let courseIsDeleted: Bool?
            }
            
            
            mutating func getCourseDetail(with courseID: String, and completion: () -> ()) {
                let manager = AFHTTPSessionManager()
                manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
                manager.GET(PartyAPI.rootURL, parameters: PartyAPI.courseStudyDetailParams(of: courseID), success: {(task: NSURLSessionDataTask, responseObject: AnyObject?) in
                    guard responseObject != nil else {
                        MsgDisplay.showErrorMsg("网络不好，请稍候再试")
                        return
                    }
                    //courselist 打错
                    guard responseObject?.objectForKey("status") as? Int == 1, let fooDetails = responseObject?.objectForKey("details") as? Array<NSDictionary> else {
                        MsgDisplay.showErrorMsg("服务器开小差啦！")
                        return
                    }
                    
                    self.courseDetails = fooDetails.flatMap({ (dict: NSDictionary) -> Detail? in
                        guard let courseID = dict["course_id"] as? String,
                              let courseName = dict["course_name"] as? String,
                              let articleID = dict["article_id"] as? String,
                              let articleName = dict["article_name"] as? String,
                              let articleContent = dict["article_content"] as? String,
                              let articleIsHidden = dict["article_ishidden"] as? Bool,
                              let articleIsDeleted = dict["article_isdeleted"] as? Bool,
                              let coursePriority = dict["course_priority"] as? String,
                              let courseDetail = dict["course_detail"] as? String,
                              let courseInsertTime = dict["course_inserttime"] as? NSDate,
                              let courseIsHidden = dict["course_ishidden"] as? Bool,
                              let courseIsDeleted = dict["course_isdeleted"] as? Bool
                            else {
                                return nil
                        }
                        return Detail(courseID: courseID, courseName: courseName, articleID: articleID, articleName: articleName, articleContent: articleContent, articleIsHidden: articleIsHidden, articleIsDeleted: articleIsDeleted, coursePriority: coursePriority, courseDetail: courseDetail, courseInsertTime: courseInsertTime, courseIsHidden: courseIsHidden, courseIsDeleted: courseIsDeleted)
                    })

                    
                    //Usually the completion is for performing tasks right after the success closure so it won't have bugs with Asynchronous stuff
                    completion()
                    }, failure: { (task: NSURLSessionDataTask?, err: NSError) in
                        MsgDisplay.showErrorMsg("出错啦！")
                })
                
                
            }
            
        }

        static func getCourseList(and completion: () -> ()) {
            let manager = AFHTTPSessionManager()
            manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
            manager.GET(PartyAPI.rootURL, parameters: PartyAPI.courseStudyParams, success: {(task: NSURLSessionDataTask, responseObject: AnyObject?) in
                guard responseObject != nil else {
                    MsgDisplay.showErrorMsg("网络不好，请稍候再试")
                    return
                }
                //courselist 打错
                guard (responseObject?.objectForKey("status"))! as? Int == 1, let fooCourses = responseObject?.objectForKey("couselist") as? Array<NSDictionary> else {
                    MsgDisplay.showErrorMsg("服务器开小差啦！")
                    return
                }
                
                courses = fooCourses.flatMap({ (dict: NSDictionary) -> Study20Course? in
                    guard let courseID = dict["course_id"] as? String, let courseName = dict["course_name"] as? String else {
                        return nil
                    }
                    return Study20Course(courseID: courseID, courseName: courseName, courseDetails: [nil], courseScore: nil)
                })
                
                //Usually the completion is for performing tasks right after the success closure so it won't have bugs with Asynchronous stuff
                completion()
            }, failure: { (task: NSURLSessionDataTask?, err: NSError) in
                    MsgDisplay.showErrorMsg("出错啦！")
            })
        }

    }
    
    
    //MARK: 预备党员党校课程学习之理论经典
    static var texts: [StudyText?] = []
    
    struct StudyText {
        let fileID: String?
        let fileTitle: String?
        let fileAddTime: NSDate?
        
        var textArticles: [Article?] = []
        
        
        struct Article {
            let articleContent: String?
        }
        
        mutating func getTextArticle(with fileID: String, and completion: () -> ()) {
            let manager = AFHTTPSessionManager()
            manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
            manager.GET(PartyAPI.rootURL, parameters: PartyAPI.studyTextDetailParams(of: fileID), success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                guard responseObject != nil else {
                    MsgDisplay.showErrorMsg("网络不好，请稍候再试")
                    return
                }
                
                //TODO: 目前不知道 filecontent 就是 String 还是 Array<NSDictionary>
                guard responseObject?.objectForKey("status") as? Int == 1, let fooArticles = responseObject?.objectForKey("file_content") as? Array<NSDictionary> else {
                    MsgDisplay.showErrorMsg("服务器开小差啦！")
                    return
                }
                
                self.textArticles = fooArticles.flatMap({ (dict: NSDictionary) -> Article? in
                    guard let articleContent = dict["foo"] as? String else {
                        return nil
                    }
                    return Article(articleContent: articleContent)
                })
                
                //Usually the completion is for performing tasks right after the success closure so it won't have bugs with Asynchronous stuff
                completion()
            }) { (task: NSURLSessionDataTask?, err: NSError) in
                MsgDisplay.showErrorMsg("出错啦！")
            }
        }
        
    }
    
    static func getTextList(and completion: () -> ()) {
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        manager.GET(PartyAPI.rootURL, parameters: PartyAPI.studyTextParams, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            guard responseObject != nil else {
                MsgDisplay.showErrorMsg("网络不好，请稍候再试")
                return
            }
            guard responseObject?.objectForKey("status") as? Int == 1, let fooTexts = responseObject?.objectForKey("textlist") as? Array<NSDictionary> else {
                MsgDisplay.showErrorMsg("服务器开小差啦！")
                return
            }
            
            texts = fooTexts.flatMap({ (dict: NSDictionary) -> StudyText? in
                guard let fileID = dict["file_id"] as? String, let fileTitle = dict["file_title"] as? String, let fileAddTime = dict["file_addtime"] as? NSDate else {
                    return nil
                }
                return StudyText(fileID: fileID, fileTitle: fileTitle, fileAddTime: fileAddTime, textArticles: [])
            })
            
            //Usually the completion is for performing tasks right after the success closure so it won't have bugs with Asynchronous stuff
            completion()
            
        }) { (task: NSURLSessionDataTask?, err: NSError) in
                MsgDisplay.showErrorMsg("出错啦！")
        }
    }
    
}