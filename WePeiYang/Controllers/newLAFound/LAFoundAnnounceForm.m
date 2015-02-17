//
//  LAFoundAnnounceForm.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "LAFoundAnnounceForm.h"

@implementation LAFoundAnnounceForm

- (NSArray *) fields {
    return @[
             
             @{FXFormFieldHeader: @"类型", FXFormFieldKey: @"type", FXFormFieldTitle: @"", FXFormFieldOptions: @[@"丢失物品", @"拾取物品"], FXFormFieldCell: [FXFormOptionSegmentsCell class]},
             
             @{FXFormFieldKey: @"title", FXFormFieldTitle: @"标题", FXFormFieldHeader: @"物品信息"},
             @{FXFormFieldKey: @"place", FXFormFieldTitle: @"地点"},
             @{FXFormFieldKey: @"time", FXFormFieldTitle: @"时间", FXFormFieldType: FXFormFieldTypeDateTime},
             
             @{FXFormFieldKey: @"name", FXFormFieldTitle: @"姓名", FXFormFieldHeader: @"联系方式"},
             @{FXFormFieldKey: @"phone", FXFormFieldTitle: @"电话", FXFormFieldType: FXFormFieldTypeNumber},
             
             @{FXFormFieldKey: @"content", FXFormFieldTitle: @"", FXFormFieldType: FXFormFieldTypeLongText, FXFormFieldHeader: @"详细描述"},
             
             @{FXFormFieldTitle: @"提交", FXFormFieldHeader: @"", FXFormFieldAction: @"announceButionAction", FXFormFieldHeader: @""}
             ];
}

@end
