//
//  GPALoginForm.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "GPALoginForm.h"

@implementation GPALoginForm

- (NSArray *)fields {
    return @[
             
             @{FXFormFieldKey: @"username", FXFormFieldTitle: @"帐号", FXFormFieldType: FXFormFieldTypeNumber, FXFormFieldHeader: @"登录办公网帐号"},
             @{FXFormFieldKey: @"password", FXFormFieldTitle: @"密码", FXFormFieldType: FXFormFieldTypePassword,
               FXFormFieldFooter: @""},
             
             @{FXFormFieldTitle: @"登录", FXFormFieldHeader: @"", FXFormFieldAction: @"login"},
             @{FXFormFieldTitle: @"取消", FXFormFieldAction: @"cancel"}
             
             ];
}

@end
