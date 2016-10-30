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
    
    func initWithDict(dic: NSDictionary) {
        self.title = dic["title"] as! String
        self.author = dic["author"] as! String
        self.isbn = dic["isbn"] as! String
    }
}