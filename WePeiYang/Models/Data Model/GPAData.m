//
//  GPAData.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/15.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "GPAData.h"
#import "MJExtension.h"
#import "GPAClassData.h"

@implementation GPAData

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"name": @"name",
             @"credit": @"stat.credit",
             @"gpa": @"stat.gpa",
             @"score": @"stat.score",
             @"term": @"term"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data": [GPAClassData class]};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"gpa"] || [property.name isEqualToString:@"score"]) {
        return [NSString stringWithFormat:@"%.2f", [oldValue floatValue]];
    }
    return oldValue;
}

@end
