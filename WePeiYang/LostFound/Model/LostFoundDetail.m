//
//  LostFoundDetail.m
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/14.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "LostFoundDetail.h"

@implementation LostFoundDetail

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"index": @"id",
             @"type": @"type",
             @"name": @"name",
             @"title": @"title",
             @"place": @"place",
             @"time": @"time",
             @"phone": @"phone",
             @"content": @"content",
             @"lostType": @"lost_type",
             @"otherTag": @"other_tag",
             @"foundPic": @"found_pic"};
}

@end
