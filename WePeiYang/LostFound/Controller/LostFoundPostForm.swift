//
//  LostFoundPostForm.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/15.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import FXForms

class LostFoundPostForm: NSObject, FXForm {
    
    var postType: Int = 0
    var title: String?
    var name: String?
    var time: NSDate?
    var place: String?
    var phone: String?
    var content: String?
    var lostType: String?
    var otherTag: String?
    var foundPic: String?
    
    func fields() -> [AnyObject]! {
        if postType == 0 {
            // Lost
            return [
                [
                    FXFormFieldHeader: "基本信息",
                    FXFormFieldTitle: "标题",
                    FXFormFieldKey: "title"
                ],
                [
                    FXFormFieldTitle: "类型",
                    FXFormFieldKey: "lostType",
                    FXFormFieldOptions: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "0"],
                    FXFormFieldValueTransformer: LostFoundTypeTransformer()
                ],
                [
                    FXFormFieldTitle: "时间",
                    FXFormFieldKey: "time",
                    FXFormFieldType: FXFormFieldTypeDateTime
                ],
                [
                    FXFormFieldTitle: "地点",
                    FXFormFieldKey: "place"
                ],
                [
                    FXFormFieldHeader: "联系信息",
                    FXFormFieldTitle: "姓名",
                    FXFormFieldKey: "name"
                ],
                [
                    FXFormFieldTitle: "电话",
                    FXFormFieldKey: "phone",
                    FXFormFieldType: FXFormFieldTypePhone
                ],
                [
                    FXFormFieldHeader: "附加信息",
                    FXFormFieldTitle: "附言",
                    FXFormFieldKey: "content",
                    FXFormFieldType: FXFormFieldTypeLongText
                ],
                [
                    FXFormFieldTitle: "其他类型",
                    FXFormFieldKey: "otherTag",
                    FXFormFieldFooter: "如果您在“类型”一栏选择“其他”，您可以在这里填写具体类型。"
                ]
            ]
        } else {
            // Found
            return [
                [
                    FXFormFieldHeader: "基本信息",
                    FXFormFieldTitle: "标题",
                    FXFormFieldKey: "title"
                ],
                [
                    FXFormFieldTitle: "时间",
                    FXFormFieldKey: "time",
                    FXFormFieldType: FXFormFieldTypeDateTime
                ],
                [
                    FXFormFieldTitle: "地点",
                    FXFormFieldKey: "place"
                ],
                [
                    FXFormFieldHeader: "联系信息",
                    FXFormFieldTitle: "姓名",
                    FXFormFieldKey: "name"
                ],
                [
                    FXFormFieldTitle: "电话",
                    FXFormFieldKey: "phone",
                    FXFormFieldType: FXFormFieldTypePhone
                ],
                [
                    FXFormFieldHeader: "附加信息",
                    FXFormFieldTitle: "附言",
                    FXFormFieldKey: "content",
                    FXFormFieldType: FXFormFieldTypeLongText
                ]
            ]
        }
    }

}
