//
//  MyBook.swift
//  YuePeiYang
//
//  Created by Halcao on 2016/10/22.
//  Copyright © 2016年 Halcao. All rights reserved.
//

import Foundation

class MyBook{
    var title: String!
    var author: String!
    var isbn: String!
    var rate: Double!
    var publisher: String!
    var year: Int!
    convenience init(dic: NSDictionary) {
        self.init()
        guard let title = dic["title"] as? String,
        author = dic["author"] as? String,
        isbn = dic["isbn"] as? String else {
            return
        }
        self.title = title
        self.author = author
        self.isbn = isbn
    }
}
