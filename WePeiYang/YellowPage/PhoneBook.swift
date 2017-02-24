//
//  PhoneBook.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/22.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit

class PhoneBook: NSObject {
    static let shared = PhoneBook()
    private override init() {}
    
    var favorite: [ClientItem] = []
    
    func getPhoneNumber(with string: String) -> String? {
        
        return ""
    }
    
    // get members with section
    func getMembers(with section: String) -> [String] {
        if section == "校级部门" {
            return ["计算机学院团委办公室", "信息学院团委办公室", "软件学院团委办公室"]
        }
        return []
    }
    
    // get sections
    func getSections() -> [String] {
        return ["校级部门", "院级部门", "其他部门"]
    }
    
    // get favorite
    func getFavorite() -> [ClientItem] {
        var models: [ClientItem] = []

        models.append(ClientItem(with: "学工部本科生教育科", phone: "27407083"))
        models.append(ClientItem(with: "学工部宿舍管理科", phone: "27407032"))
        models.append(ClientItem(with: "学工部研究生教育管理科", phone: "27407011"))
        models.append(ClientItem(with: "学工部学生档案室", phone: "27407023"))
        return models
    }
    
    // get models with member name
    func getModels(with member: String) -> [ClientItem] {
        var models: [ClientItem] = []
        models.append(ClientItem(with: "学工部本科生教育科", phone: "27407083"))
        models.append(ClientItem(with: "学工部宿舍管理科", phone: "27407032"))
        models.append(ClientItem(with: "学工部研究生教育管理科", phone: "27407011"))
        models.append(ClientItem(with: "学工部学生档案室", phone: "27407023"))
        return models
    }
    
    func getItems(with string: String) -> [ClientItem] {
        if string == "" {
            return []
        }
        var models: [ClientItem] = []
        models.append(ClientItem(with: "学工部本科生教育科", phone: "27407083"))
        models.append(ClientItem(with: "学工部宿舍管理科", phone: "27407032"))
        models.append(ClientItem(with: "学工部研究生教育管理科", phone: "27407011"))
        models.append(ClientItem(with: "学工部学生档案室", phone: "27407023"))
        return models
    }
    
}
