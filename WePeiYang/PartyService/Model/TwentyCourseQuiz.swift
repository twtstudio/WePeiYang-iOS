//
//  TwentyCourseQuiz.swift
//  WePeiYang
//
//  Created by Allen X on 8/23/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

extension Courses.Study20 {
    
    struct QuizOption {
        let name: String
        let weight: Int
    }
    
    struct Quiz {
        let id: String
        let belongTO: String
        let type: String
        let content: String
        let answer: String
        let isHidden: String
        let isDeleted: String
        let options: [QuizOption]
        var choosenOnesAtIndex: [Int]? = nil
        var userAnswer: Int?
    }
    
    static func getQuiz(of CourseID: String, and completion: () -> ()) {
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        /*
        let requestSerializer = AFJSONRequestSerializer()
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = requestSerializer
        */
        manager.GET(PartyAPI.rootURL, parameters: PartyAPI.courseQuizParams(of: CourseID), progress: { (_: NSProgress) in
            MsgDisplay.showLoading()
            }, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                
                MsgDisplay.dismiss()
                guard responseObject != nil else {
                    MsgDisplay.showErrorMsg("哎呀，出错啦")
                    //log.word("fuck1")/
                    return
                }
                
                guard responseObject?.objectForKey("status") as? Int == 1 else {
                    guard let msg = responseObject?.objectForKey("msg") as? String else {
                        MsgDisplay.showErrorMsg("未知错误1")
                        //log.word("fuck2")/
                        return
                    }
                    
                    MsgDisplay.showErrorMsg(msg)
                    //log.word("fuck1\(msg)")/
                    return
                }
                
                guard let fooQuizes = responseObject?.objectForKey("data") as? Array<NSDictionary> else {
                    MsgDisplay.showErrorMsg("服务器开小差啦")
                    //log.word("fuck3")/
                    return
                }
                
                Courses.Study20.courseQuizes = fooQuizes.flatMap({ (dict: NSDictionary) -> Quiz? in
                    guard let id = dict["exercise_id"] as? String,
                          let belongTo = dict["course_id"] as? String,
                          let type = dict["exercise_type"] as? String,
                          let content = dict["exercise_content"] as? String,
                          let answer = dict["exercise_answer"] as? String,
                          let isHidden = dict["exercise_ishidden"] as? String,
                          let isDeleted = dict["exercise_isdeleted"] as? String,
                          let fooOptions = dict["choose"] as? Array<NSDictionary>
                    else {
                            MsgDisplay.showErrorMsg("未知错误2")
                            //log.word("fuck4")/
                            return nil
                    }
                    
                    let options = fooOptions.flatMap({ (dict: NSDictionary) -> QuizOption? in
                        guard let name = dict["name"] as? String,
                            let weight = dict["pos"] as? Int else {
                                return nil
                        }
                        return QuizOption(name: name, weight: weight)
                    })
                    
                    guard options.count != 0 else {
                        MsgDisplay.showErrorMsg("未知错误3")
                        //log.word("fuck5")/
                        return nil
                    }
                    
                    return Quiz(id: id, belongTO: belongTo, type: type, content: content, answer: answer, isHidden: isHidden, isDeleted: isDeleted, options: options, choosenOnesAtIndex: nil, userAnswer: nil)
                    
                })
                
                completion()
                
        }) { (_: NSURLSessionDataTask?, err: NSError) in
                MsgDisplay.showErrorMsg("网络不好，请稍后重试")
            log.any(err)/
        }
    }
    
    static func submitAnswer(of courseID: String, answer: [Int], userAnswer: [Int], and completion: () -> ()) {
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
        manager.POST(PartyAPI.courseQuizSubmitURL, parameters: PartyAPI.courseQuizSubmitParams(of: courseID, originalAnswer: answer, userAnswer: userAnswer), progress: { (_: NSProgress) in
            MsgDisplay.showLoading()
            }, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
                MsgDisplay.dismiss()
                
                guard responseObject != nil else {
                    MsgDisplay.showErrorMsg("哎呀，出错啦")
                    log.word("fuck1")/
                    return
                }
                
                log.any(responseObject)/
                
                guard responseObject?.objectForKey("status") as? Int == 1 else {
                    guard let msg = responseObject?.objectForKey("msg") as? String else {
                        MsgDisplay.showErrorMsg("提交答案失败，别担心，等网络好了，我们会再次帮你提交一遍")
                        Courses.Study20.finalMsgAfterSubmitting = "提交答案失败，别担心，等网络好了，我们会再次帮你提交一遍"
                        log.word("fuck2")/
                        completion()
                        return
                    }
                    MsgDisplay.showErrorMsg(msg)
                    Courses.Study20.finalMsgAfterSubmitting = msg
                    log.word(msg)/
                    completion()
                    return
                }
                
                guard let msg = responseObject?.objectForKey("msg") as? String else {
                    MsgDisplay.showErrorMsg("网络出问题啦，别担心，等网络好了，我们会再次帮你提交一遍")
                    Courses.Study20.finalMsgAfterSubmitting = "网络出问题啦，别担心，等网络好了，我们会再次帮你提交一遍"
                    log.word("fuck4")/
                    completion()
                    return
                }
                
                Courses.Study20.finalMsgAfterSubmitting = msg
                log.word("fuck5")/
                completion()
                
        }) { (_: NSURLSessionDataTask?, err: NSError) in
                MsgDisplay.showErrorMsg("网络不好，请稍后重试2")
            log.error(err)/
            log.word("wrong2")/
        }
        
    }
}
