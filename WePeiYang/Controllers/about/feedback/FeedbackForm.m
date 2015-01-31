//
//  FeedbackForm.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/21.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "FeedbackForm.h"
#import "wpyDeviceStatus.h"

@implementation FeedbackForm

- (NSArray *)fields {
    
    NSString *deviceModel = [wpyDeviceStatus getDeviceModel];
    NSString *deviceVersion = [wpyDeviceStatus getDeviceOSVersion];
    
    return @[
             
             @{FXFormFieldKey: @"contact", FXFormFieldTitle: @"联系方式", FXFormFieldHeader: @"基本信息"},
             @{FXFormFieldKey: @"deviceModel", FXFormFieldTitle: @"设备型号", FXFormFieldType: FXFormFieldTypeLabel, FXFormFieldDefaultValue: deviceModel},
             @{FXFormFieldKey: @"deviceVersion", FXFormFieldTitle: @"设备版本", FXFormFieldType: FXFormFieldTypeLabel, FXFormFieldDefaultValue: deviceVersion},
             
             @{FXFormFieldKey: @"advices", FXFormFieldTitle: @"", FXFormFieldType: FXFormFieldTypeLongText, FXFormFieldHeader: @"反馈"},
    
            @{FXFormFieldTitle: @"提交反馈", FXFormFieldHeader: @"", FXFormFieldAction: @"submitFeedback:"},

            ];
}

@end
