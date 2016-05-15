//
//  NewsContent.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/12/6.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "NewsContent.h"
#import "MJExtension.h"
#import "NewsComment.h"

@implementation NewsContent

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"index": @"index",
             @"subject": @"subject",
             @"content": @"content",
             @"source": @"newscome",
             @"author": @"gonggao",
             @"reviewer": @"shengao",
             @"photographer": @"sheying",
             @"visitCount": @"visitcount",
             @"comments": @"comments"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"comments": [NewsComment class]};
}

@end
