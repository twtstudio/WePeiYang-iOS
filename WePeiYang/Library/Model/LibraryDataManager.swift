//
//  LibraryDataManager.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/4/20.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import FMDB

let LIBRARY_FAVORITE_DB_NAME = "fav.db"

class LibraryDataManager: NSObject {
    
    class func searchLibrary(keyword: String, page: Int, success: (data: [LibraryDataItem]) -> (), failure: (errorMsg: String) -> ()) {
        twtSDK.getLibrarySearchResultWithTitle(keyword, page: page, success: { (task, responseObject) in
            let jsonData = JSON(responseObject)
            if jsonData["error_code"].intValue == -1 {
                if let data = Mapper<LibraryDataItem>().mapArray(jsonData["data"].arrayObject) {
                    success(data: data)
                }
            }
        }, failure: { (task, error) in
            failure(errorMsg: error.localizedDescription)
        })
    }
    
    class func addLibraryItemToFavorite(item: LibraryDataItem) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent(LIBRARY_FAVORITE_DB_NAME)
        let database = FMDatabase(path: fileURL!.path)
        
        if !database.open() {
            return
        }
        
        do {
            try database.executeUpdate("CREATE TABLE Libfav(id, title, author, publisher, location)", values: nil)
        } catch let error as NSError {
            print("Failed: \(error.localizedDescription)")
        }
        
        do {
            try database.executeUpdate("INSERT INTO Libfav VALUES(?, ?, ?, ?, ?)", values: [item.index, item.title, item.author, item.publisher, item.location])
        } catch let error as NSError {
            print("Failed: \(error.localizedDescription)")
        }
        
        database.close()
    }
    
    class func favoriteLibraryItems() -> [LibraryDataItem] {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent(LIBRARY_FAVORITE_DB_NAME)
        let database = FMDatabase(path: fileURL!.path)
        
        if !database.open() {
            return []
        }
        
        var dataArr: [LibraryDataItem] = []
        do {
            let result = try database.executeQuery("SELECT * FROM Libfav", values: nil)
            while result.next() {
                let item = LibraryDataItem(index: result.stringForColumn("id"), title: result.stringForColumn("title"), author: result.stringForColumn("author"), publisher: result.stringForColumn("publisher"), location: result.stringForColumn("location"))
                dataArr.append(item)
            }
        } catch let error as NSError {
            print("Failed: \(error.localizedDescription)")
        }
        
        database.close()
        return dataArr
    }
    
    class func removeLibraryItem(item: LibraryDataItem) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent(LIBRARY_FAVORITE_DB_NAME)
        let database = FMDatabase(path: fileURL!.path)
        
        if !database.open() {
            return
        }
        
        do {
            try database.executeUpdate("DELETE FROM Libfav WHERE id=?", values: [item.index])
        } catch let error as NSError {
            print("Failed: \(error.localizedDescription)")
        }
        
        database.close()
    }

}
