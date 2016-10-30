
//
//  MyReview.swift
//  YuePeiYang
//
//  Created by Halcao on 2016/10/22.
//  Copyright © 2016年 Halcao. All rights reserved.
//
/*
 {
    content: String
    rate: Number
    like: Number
    timestamp: Long
    book: {
        title: String
        isbn: String
    }
 }
*/

import Foundation

class MyReview {
    var content: String!
    var rate: Int!
    var like: Int!
    var timestamp: String!
    var book: MyBook!
    var avatar_url: String!
    var username: String!
    var id: Int!
    
    convenience init(dic: NSDictionary)
    {
        self.init()
        guard let content = dic["content"] as? String,
        rate = dic["rate"] as? Int,
        like = dic["like"] as? Int,
        bdic = dic["book"] as? NSDictionary,
        udic = dic["user"] as? NSDictionary,
        timestamp = dic["timestamp"] as? String else {
            // Msg
            // TODO: 提示解析错误
            return
        }
        
        book = MyBook(dic: bdic)
        self.content = content
        self.rate = rate
        self.like = like
        self.timestamp = timestamp

        guard let username = udic["name"] as? String,
        id = udic["id"] as? Int,
            avatar = udic["avatar"] as? String else {
                // TODO: 提示解析错误
                return
        }
        self.username = username
        self.id = id
        self.avatar_url = avatar
        // TODO: 头像
        // 默认有头像
        
    }
}