//
//  Review.swift
//  WePeiYang
//
//  Created by Allen X on 10/29/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import Foundation

class Review {
    let reviewID: String
    let bookID: String
    let bookName: String
    let userName: String
    let avatarURL: String
    let rating: Double
    let like: String
    let content: String
    let updateTime: String
    let liked: Bool
    
    init(reviewID: String, bookID: String, bookName: String, userName: String, avatarURL: String, rating: Double, like: String, content: String, updateTime: String, liked: Bool) {
        self.reviewID = reviewID
        self.bookID = bookID
        self.bookName = bookName
        self.userName = userName
        self.avatarURL = avatarURL
        self.rating = rating
        self.like = like
        self.content = content
        self.updateTime = updateTime
        self.liked = liked
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