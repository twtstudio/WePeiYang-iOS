//
//  ClassroomAPI.swift
//  WePeiYang
//
//  Created by Allen X on 3/5/17.
//  Copyright © 2017 Qin Yubo. All rights reserved.
//

import Foundation

extension Classroom {
    struct API {
        static let rootURL = "http://120.27.115.59/test_laravel/public/index.php/api/Classroom/"
        static let showFavouriteURL = rootURL + "showCollection"
        static let queryClassroomURL = rootURL + "getClassroom"
        static let addFavClassroomURL = rootURL + "roomCollection"
        static let removeFavouriteURL = rootURL + "removeCollection"
        
        
    }
}
