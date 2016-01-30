//
//  BindTjuForm.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/30.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import FXForms

class BindTjuForm: NSObject, FXForm {
    
    var username: String!
    var password: String!
    
    func fields() -> [AnyObject]! {
        return [
            [
                FXFormFieldHeader: "绑定办公网",
                FXFormFieldTitle: "账号",
                FXFormFieldKey: "username",
                FXFormFieldPlaceholder: "请输入办公网账号"
            ],
            [
                FXFormFieldTitle: "密码",
                FXFormFieldKey: "password",
                FXFormFieldPlaceholder: "请输入办公网密码",
                FXFormFieldType: FXFormFieldTypePassword,
                FXFormFieldFooter: "绑定天外天账号与办公网账号后，您可以访问您的成绩等信息。"
            ]
        ]
    }
    
    func usernameField() -> [String: AnyObject]! {
        return [
            "textField.textAlignment": NSTextAlignment.Left.rawValue,
            "textLabel.font": UIFont.systemFontOfSize(17.0)
        ]
    }
    
    func passwordField() -> [String: AnyObject]! {
        return [
            "textField.textAlignment": NSTextAlignment.Left.rawValue,
            "textLabel.font": UIFont.systemFontOfSize(17.0)
        ]
    }

}
