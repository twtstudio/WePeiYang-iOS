//
//  GPAStat.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/16.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "GPAStat.h"
#import "MJExtension.h"

@implementation GPAStat

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"doubleStr": @"double",
             @"credit": @"total.credit",
             @"gpa": @"total.gpa",
             @"score": @"total.score"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"gpa"] || [property.name isEqualToString:@"score"]) {
        return [NSString stringWithFormat:@"%.2f", [oldValue floatValue]];
    }
    return oldValue;
}

@end
