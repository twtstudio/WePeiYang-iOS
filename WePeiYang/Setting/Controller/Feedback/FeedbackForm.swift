//
//  FeedbackForm.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/17.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import FXForms

class FeedbackForm: NSObject, FXForm {
    
    var content: String?
    var email: String?
    var deviceModel: String!
    var iosVersion: String!
    var appVersion: String!
    
    func fields() -> [AnyObject]! {
        return [
            [
                FXFormFieldHeader: "反馈信息",
                FXFormFieldTitle: "联系方式",
                FXFormFieldKey: "email"
            ],
            [
                FXFormFieldTitle: "反馈内容",
                FXFormFieldKey: "content",
                FXFormFieldType: FXFormFieldTypeLongText,
                FXFormFieldFooter: "非常感谢您的反馈。\n微北洋因你而变得更好！"
            ],
            [
                FXFormFieldHeader: "基本信息",
                FXFormFieldTitle: "设备型号",
                FXFormFieldKey: "deviceModel",
                FXFormFieldDefaultValue: wpyDeviceStatus.getDeviceModel()
            ],
            [
                FXFormFieldTitle: "iOS 版本",
                FXFormFieldKey: "iosVersion",
                FXFormFieldDefaultValue: "iOS \(wpyDeviceStatus.getDeviceOSVersion())"
            ],
            [
                FXFormFieldTitle: "微北洋版本",
                FXFormFieldKey: "appVersion",
                FXFormFieldDefaultValue: "\(wpyDeviceStatus.getAppVersion()) Build \(wpyDeviceStatus.getAppBuild())",
                FXFormFieldFooter: "我们只收集以上基本信息以更好的改进我们的产品。"
            ]
        ]
    }
    
    func deviceModelField() -> [String: AnyObject]! {
        return [
            "textField.textAlignment": NSTextAlignment.Left.rawValue,
            "textField.userInteractionEnabled": false,
            "textLabel.font": UIFont.systemFontOfSize(17.0)
        ]
    }
    
    func iosVersionField() -> [String: AnyObject]! {
        return [
            "textField.textAlignment": NSTextAlignment.Left.rawValue,
            "textField.userInteractionEnabled": false,
            "textLabel.font": UIFont.systemFontOfSize(17.0)
        ]
    }
    
    func appVersionField() -> [String: AnyObject]! {
        return [
            "textField.textAlignment": NSTextAlignment.Left.rawValue,
            "textField.userInteractionEnabled": false,
            "textLabel.font": UIFont.systemFontOfSize(17.0)
        ]
    }
    
    func emailField() -> [String: AnyObject]! {
        return [
            "textField.textAlignment": NSTextAlignment.Left.rawValue,
            "textLabel.font": UIFont.systemFontOfSize(17.0)
        ]
    }
    
    func contentField() -> [String: AnyObject]! {
        return [
            "textLabel.font": UIFont.systemFontOfSize(17.0)
        ]
    }
    
}
