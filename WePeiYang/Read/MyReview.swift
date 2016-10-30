
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

class Review {
    let bookID: String
    let title: String
    let userName: String
    let avatarURL: String
    let rating: Double
    let like: String
    let content: String
    let updateTime: String
    
    init(bookID: String, title: String, userName: String, avatarURL: String, rating: Double, like: String, content: String, updateTime: String) {
        self.bookID = bookID
        self.title = title
        self.userName = userName
        self.avatarURL = avatarURL
        self.rating = rating
        self.like = like
        self.content = content
        self.updateTime = updateTime
    }
}