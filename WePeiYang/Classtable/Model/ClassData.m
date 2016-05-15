//
//  ClassData.m
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/28.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "ClassData.h"

@implementation ClassData

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"classId": @"classid",
             @"courseId": @"courseid",
             @"courseName": @"coursename",
             @"courseType": @"coursetype",
             @"courseNature": @"coursenature",
             @"credit": @"credit",
             @"teacher": @"teacher",
             @"arrange": @"arrange",
             @"weekStart": @"week.start",
             @"weekEnd": @"week.end",
             @"college": @"college",
             @"campus": @"campus",
             @"ext": @"ext"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"arrange": @"ArrangeModel"};
}

@end
