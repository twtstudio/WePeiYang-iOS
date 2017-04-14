
//
//  PhoneBook.swift
//  WePeiYang
//
//  Created by Halcao on 2017/4/8.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

let YELLOWPAGE_SAVE_KEY = "YellowPageItems"
class PhoneBook: NSObject {
    static let shared = PhoneBook()
    private override init() {}
    
    static let url = "http://open.twtstudio.com/api/v1/yellowpage/data3"
    var favorite: [ClientItem] = []
    var sections: [String] = []
    var members: [String: [String]] = [:]
    var items: [ClientItem] = []
    
    // given a name, return its phone number
    func getPhoneNumber(with string: String) -> String? {
        for item in items {
            if item.name.containsString(string) {
                return item.phone
            }
        }
        return nil
    }
    
    // get members with section
    func getMembers(with section: String) -> [String] {
        guard let dict = members[section] else {
            return []
        }
        return dict
    }

    func addToFavorite(with name: String, success: ()->()) {
        for item in items {
            if item.name == name {
                item.isFavorite = true
                favorite.append(item)
                success()
                return
            }
        }
        
    }
    
    func removeFromFavorite(with name: String, success: ()->()) {
        for item in items {
            if item.name == name {
                item.isFavorite = false
                break
            }
        }

        favorite = favorite.filter { item in
            return name != item.name
        }
        success()
    }
    
    // get models with member name
    func getModels(with member: String) -> [ClientItem] {
        return items.filter { item in
            return item.owner == member
        }
    }
    
    // seach result
    func getResult(with string: String) -> [ClientItem] {
        return items.filter { item in
            return item.name.containsString(string)
        }
    }
    
    static func checkVersion(success: ()->()) {
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes?.insert("text/json")
        manager.responseSerializer.acceptableContentTypes?.insert("text/javascript")
        manager.responseSerializer.acceptableContentTypes?.insert("text/html")
        manager.GET(PhoneBook.url, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) in
            //
            guard let dict = responseObject as? Dictionary<String, AnyObject> else {
                    MsgDisplay.showErrorMsg("身份认证失败")
                    return
            }
            if let categories = dict["category_list"] as? Array<Dictionary<String, AnyObject>> {
                for category in categories {
                    let category_name = category["category_name"] as! String
                    PhoneBook.shared.sections.append(category_name)
                    if let departments = category["department_list"] as? Array<Dictionary<String, AnyObject>>{
                        for department in departments {
                            let department_name = department["department_name"] as! String
                            if PhoneBook.shared.members[category_name] != nil {
                                PhoneBook.shared.members[category_name]!.append(department_name)
                            } else {
                                PhoneBook.shared.members[category_name] = [department_name]
                            }
                            let items = department["unit_list"] as! Array<Dictionary<String, String>>
                            for item in items {
                                let item_name = item["item_name"]
                                let item_phone = item["item_phone"]
                                PhoneBook.shared.items.append(ClientItem(with: item_name!, phone: item_phone!, owner: department_name))
                            }
                        }
                    }
                }
            }
            PhoneBook.shared.save()
            success()
            }, failure: { (_, error) in
                log.error(error)/
                MsgDisplay.showErrorMsg("身份认证失败")
        })
    }
    
    private func request() {
        
    }
    
}

extension PhoneBook {
    func save() {
        let path = self.dataFilePath()
        //声明文件管理器
        let defaultManager = NSFileManager()
        if defaultManager.fileExistsAtPath(path) {
            try! defaultManager.removeItemAtPath(path)
        }

        let data = NSMutableData()
        //申明一个归档处理对象
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        //将lists以对应Checklist关键字进行编码
        archiver.encodeObject(PhoneBook.shared.items, forKey: YELLOWPAGE_SAVE_KEY)
        archiver.encodeObject(PhoneBook.shared.members, forKey: "yp_member_key")
        archiver.encodeObject(PhoneBook.shared.sections, forKey: "yp_section_key")
        archiver.encodeObject(PhoneBook.shared.favorite, forKey: "yp_favorite_key")
        //编码结束
        archiver.finishEncoding()
        //数据写入
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    //读取数据
    func load(success: ()->(), failure: ()->()) {
        //获取本地数据文件地址
        let path = self.dataFilePath()
        //声明文件管理器
        let defaultManager = NSFileManager()
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExistsAtPath(path) {
            //读取文件数据
            let url = NSURL(fileURLWithPath: path)
            let data = NSData(contentsOfURL: url)
            //解码器
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
            //通过归档时设置的关键字Checklist还原lists
            if let array = unarchiver.decodeObjectForKey(YELLOWPAGE_SAVE_KEY) as? Array<ClientItem>,
            let favorite = unarchiver.decodeObjectForKey("yp_favorite_key") as? Array<ClientItem>,
            let members = unarchiver.decodeObjectForKey("yp_member_key") as? [String: [String]],
            let sections = unarchiver.decodeObjectForKey("yp_section_key") as? [String] {
                guard array.count > 0 else {
                    failure()
                    return
                }
                PhoneBook.shared.favorite = favorite
                PhoneBook.shared.members = members
                PhoneBook.shared.sections = sections
                PhoneBook.shared.items = array
                unarchiver.finishDecoding()
                success()
                return
            }
            //结束解码
        }
        failure()
    }
    
    //获取数据文件地址
    func dataFilePath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths.first!
        return documentsDirectory + "/YellowPage.plist"
    }
}
