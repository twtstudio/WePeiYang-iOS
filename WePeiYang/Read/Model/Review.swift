//
//  Review.swift
//  WePeiYang
//
//  Created by Allen X on 10/29/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import Foundation

class Review {
    let bookID: String
    let bookName: String
    let userName: String
    let avatarURL: String
    let rating: Double
    let like: String
    let content: String
    let updateTime: String
    
    init(bookID: String, bookName: String, userName: String, avatarURL: String, rating: Double, like: String, content: String, updateTime: String) {
        self.bookID = bookID
        self.bookName = bookName
        self.userName = userName
        self.avatarURL = avatarURL
        self.rating = rating
        self.like = like
        self.content = content
        self.updateTime = updateTime
    }
}

class StarReview {
    let name: String
    let content: String
    
    init(name: String, content: String) {
        self.name = name
        self.content = content
    }
}