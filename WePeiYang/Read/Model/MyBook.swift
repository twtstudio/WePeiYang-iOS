//
//  MyBook.swift
//  WePeiYang
//
//  Created by Halcao on 2016/11/1.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

struct MyBook {
    let title: String
    let author: String
    let id: Int
    
    init(title: String, author: String, id: Int){
        self.title = title
        self.author = author
        self.id = id
    }
}