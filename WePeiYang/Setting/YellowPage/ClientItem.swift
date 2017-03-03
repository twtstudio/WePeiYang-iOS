//
//  ClientItem.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/22.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import Foundation

class ClientItem: NSObject {
    var name = ""
    var phone = ""
    var isFavorite = false
    
    init(with name: String, phone: String, isFavorite: Bool) {
        self.name = name
        self.phone = phone
        self.isFavorite = isFavorite
    }
}
