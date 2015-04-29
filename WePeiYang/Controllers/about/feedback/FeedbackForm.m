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
             //@{FXFormFieldKey: @"deviceModel", FXFormFieldTitle: @"设备型号", FXFormFieldType: FXFormFieldTypeLabel, FXFormFieldDefaultValue: deviceModel},
             @{FXFormFieldKey: @"deviceModel", FXFormFieldTitle: @"设备型号",  FXFormFieldDefaultValue: deviceModel},
             @{FXFormFieldKey: @"deviceVersion", FXFormFieldTitle: @"iOS 版本", FXFormFieldDefaultValue: deviceVersion},
             
             @{FXFormFieldKey: @"advices", FXFormFieldTitle: @"", FXFormFieldType: FXFormFieldTypeLongText, FXFormFieldHeader: @"反馈"},
    
            @{FXFormFieldTitle: @"提交反馈", FXFormFieldHeader: @"", FXFormFieldAction: @"submitFeedback:"},

            ];
}

- (NSDictionary *)contactField {
    //UITextField *field = [[UITextField alloc]init];
    //field.userInteractionEnabled
    return @{@"textField.textAlignment": @(NSTextAlignmentLeft),
             @"textLabel.font": [UIFont systemFontOfSize:17.0]};
}

- (NSDictionary *)deviceModelField {
    return @{@"textField.textAlignment": @(NSTextAlignmentLeft),
             @"textField.userInteractionEnabled": @NO,
             @"textLabel.font": [UIFont systemFontOfSize:17.0]};
}

- (NSDictionary *)deviceVersionField {
    return @{@"textField.textAlignment": @(NSTextAlignmentLeft),
             @"textField.userInteractionEnabled": @NO,
             @"textLabel.font": [UIFont systemFontOfSize:17.0]};
}

@end
