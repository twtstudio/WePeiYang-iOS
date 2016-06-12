//
//  DevSessionRecorder.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/6/2.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import FMDB

let SESSION_RECORD_DATABASE = "sessionRecord.db"

class DevSessionRecorder: NSObject {
    
    class func recordSession(url: String, type: Int, parameters: [String: String], response: AnyObject) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent(SESSION_RECORD_DATABASE)
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            return
        }
        
        do {
            try database.executeUpdate("create table SessionRecord(id, url, type, parameters, response)", values: nil)
        } catch let error as NSError {
            print("Failed: \(error.localizedDescription)")
        }
        
        do {
            try database.executeUpdate("insert into SessionRecord values (?, ?, ?, ?, ?)", values: [Int(NSDate().timeIntervalSince1970), url, type, NSKeyedArchiver.archivedDataWithRootObject(parameters), NSKeyedArchiver.archivedDataWithRootObject(response)])
        } catch let error as NSError {
            print("Failed: \(error.localizedDescription)")
        }
        
        database.close()
    }
    
    class func allSessionRecords() -> [DevSessionRecord] {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent(SESSION_RECORD_DATABASE)
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            return []
        }
        
        var dataArr: [DevSessionRecord] = []
        do {
            let result = try database.executeQuery("SELECT * FROM SessionRecord ORDER BY id DESC", values: nil)
            while result.next() {
                let item = DevSessionRecord(id: Int(result.intForColumn("id")), url: result.stringForColumn("url"), type: Int(result.intForColumn("type")), parameters: (NSKeyedUnarchiver.unarchiveObjectWithData(result.dataForColumn("parameters")) as! [String: AnyObject]), response: NSKeyedUnarchiver.unarchiveObjectWithData(result.dataForColumn("response"))!)
                dataArr.append(item)
            }
        } catch let error as NSError {
            print("Failed: \(error.localizedDescription)")
        }
        
        database.close()
        return dataArr
    }
    
    class func removeSessionRecord(record: DevSessionRecord) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent(SESSION_RECORD_DATABASE)
        let database = FMDatabase(path: fileURL.path)
        
        if !database.open() {
            return
        }
        
        do {
            try database.executeUpdate("delete from SessionRecord where id=?", values: [record.id!])
        } catch let error as NSError {
            print("Failed: \(error.localizedDescription)")
        }
        
        database.close()
    }

}
