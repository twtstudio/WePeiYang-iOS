//
//  LostFoundDetailForm.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/15.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import FXForms

class LostFoundDetailForm: NSObject, FXForm {

    var detailItem: LostFoundDetail!
    
    func fields() -> [AnyObject]! {
        if detailItem.type == 0 {
            // Lost
            return [
                [
                    FXFormFieldHeader: "基本信息",
                    FXFormFieldTitle: "标题",
                    FXFormFieldDefaultValue: self.notNullString(detailItem.title),
                    "textField.userInteractionEnabled": false
                ],
                [
                    FXFormFieldTitle: "类型",
                    FXFormFieldDefaultValue: self.notNullString(self.typeStringFromLostType(detailItem)),
                    "textField.userInteractionEnabled": false
                ],
                [
                    FXFormFieldTitle: "时间",
                    FXFormFieldDefaultValue: self.notNullString(detailItem.time),
                    "textField.userInteractionEnabled": false
                ],
                [
                    FXFormFieldTitle: "地点",
                    FXFormFieldDefaultValue: self.notNullString(detailItem.place),
                    "textField.userInteractionEnabled": false
                ],
                [
                    FXFormFieldHeader: "联系人",
                    FXFormFieldTitle: "姓名",
                    FXFormFieldDefaultValue: self.notNullString(detailItem.name),
                    "textField.userInteractionEnabled": false
                ],
                [
                    FXFormFieldTitle: "联系电话",
                    FXFormFieldDefaultValue: self.notNullString(detailItem.phone),
                    "textField.userInteractionEnabled": false
                ],
                [
                    FXFormFieldHeader: "附言",
                    FXFormFieldDefaultValue: self.notNullString(detailItem.content),
                    FXFormFieldType: FXFormFieldTypeLongText,
                    "textView.editable": false
                ]
            ]
        } else {
            return [
                [
                    FXFormFieldHeader: "基本信息",
                    FXFormFieldTitle: "标题",
                    FXFormFieldDefaultValue: self.notNullString(detailItem.title),
                    "textField.userInteractionEnabled": false
                ],
                [
                    FXFormFieldTitle: "时间",
                    FXFormFieldDefaultValue: self.notNullString(detailItem.time),
                    "textField.userInteractionEnabled": false
                ],
                [
                    FXFormFieldTitle: "地点",
                    FXFormFieldDefaultValue: self.notNullString(detailItem.place),
                    "textField.userInteractionEnabled": false
                ],
                [
                    FXFormFieldHeader: "联系人",
                    FXFormFieldTitle: "姓名",
                    FXFormFieldDefaultValue: self.notNullString(detailItem.name),
                    "textField.userInteractionEnabled": false
                ],
                [
                    FXFormFieldTitle: "联系电话",
                    FXFormFieldDefaultValue: self.notNullString(detailItem.phone),
                    "textField.userInteractionEnabled": false
                ],
                [
                    FXFormFieldHeader: "附言",
                    FXFormFieldDefaultValue: self.notNullString(detailItem.content),
                    FXFormFieldType: FXFormFieldTypeLongText,
                    "textView.editable": false
                ]
//                [
//                    FXFormFieldTitle: "图片",
//                    FXFormFieldDefaultValue: self.notNullString(detailItem.foundPic),
//                    FXFormFieldType: FXFormFieldTypeImage,
//                ]
            ]
        }
    }
    
    func notNullString(str: String?) -> String {
        return (str == nil) ? "" : str!
    }
    
    func typeStringFromLostType(item: LostFoundDetail?) -> String {
        if item == nil {
            return ""
        } else {
            switch item!.type {
            case 0:
                return self.notNullString(item!.otherTag)
            case 1:
                return "银行卡"
            case 2:
                return "饭卡 & 身份证"
            case 3:
                return "钥匙"
            case 4:
                return "书包"
            case 5:
                return "电脑包"
            case 6:
                return "手表 & 饰品"
            case 7:
                return "U 盘 & 硬盘"
            case 8:
                return "水杯"
            case 9:
                return "书"
            case 10:
                return "手机"
            default:
                return ""
            }
        }
    }
    
}
