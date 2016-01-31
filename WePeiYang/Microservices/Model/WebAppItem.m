//
//  WebAppItem.m
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/31.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "WebAppItem.h"
#import "MJExtension.h"

@implementation WebAppItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"desc": @"description",
             @"iconUrl": @"icon_url",
             @"name": @"name",
             @"sites": @"sites"};
}

@end
