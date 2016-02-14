//
//  LostFoundItem.m
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/14.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "LostFoundItem.h"

@implementation LostFoundItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"index": @"id",
             @"name": @"name",
             @"title": @"title",
             @"place": @"place",
             @"time": @"time",
             @"phone": @"phone",
             @"lostType": @"lost_type",
             @"otherTag": @"other_tag",
             @"foundPic": @"found_pic"};
}

@end
