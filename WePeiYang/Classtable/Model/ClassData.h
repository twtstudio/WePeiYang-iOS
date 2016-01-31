//
//  ClassData.h
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/28.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "ArrangeModel.h"

@interface ClassData : NSObject

@property (strong, nonatomic) NSString *classId;
@property (strong, nonatomic) NSString *courseId;
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *courseType;
@property (strong, nonatomic) NSString *courseNature;
@property (strong, nonatomic) NSString *credit;
@property (strong, nonatomic) NSString *teacher;
@property (strong, nonatomic) NSArray *arrange;
@property (nonatomic) NSInteger weekStart;
@property (nonatomic) NSInteger weekEnd;
@property (strong, nonatomic) NSString *college;
@property (strong, nonatomic) NSString *campus;
@property (strong, nonatomic) NSString *ext;

@end
