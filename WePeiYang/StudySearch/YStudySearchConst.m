//
//  YStudySearchConst.m
//  StudySearch
//
//  Created by yong.h on 13-10-2.
//  Copyright (c) 2013年 yong.h. All rights reserved.
//

#import "YStudySearchConst.h"

static YStudySearchConst *INSTANCE;

@implementation YStudySearchConst

- (id)init
{
    self = [super init];
    if (self) {
        self.startTimeArray = [[NSArray alloc] initWithObjects:@"08:00", @"08:30", @"09:00", @"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00", nil];
        self.endTimeArray = [[NSArray alloc] initWithArray:self.startTimeArray];
        self.buildingsArray = [[NSArray alloc] initWithObjects:@"04楼",@"05楼",@"08楼",@"12楼",@"15楼",@"19楼",@"23楼",@"24楼",@"26楼A区",@"26楼B区",@"西阶", nil];
        self.daySelected = @"0";
    }
    return self;
}

+ (YStudySearchConst *)shareInstance
{
    if (!INSTANCE) {
        INSTANCE = [[YStudySearchConst alloc] init];
    }
    
    return INSTANCE;
}

-(void)dealloc
{
    self.testData = nil;
    self.startTimeArray = nil;
    self.endTimeArray = nil;
    self.buildingsArray = nil;
    self.studySearchUrl = nil;
    self.daySelected = nil;
}

@end
