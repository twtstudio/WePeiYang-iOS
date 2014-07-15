//
//  YStudySearchConst.h
//  StudySearch
//
//  Created by yong.h on 13-10-2.
//  Copyright (c) 2013年 yong.h. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YStudySearchConst : NSObject

@property (strong, nonatomic) NSArray *testData;
@property (strong, nonatomic) NSArray *startTimeArray;
@property (strong, nonatomic) NSArray *endTimeArray;
@property (strong, nonatomic) NSArray *buildingsArray;
@property (strong, nonatomic) NSURL *studySearchUrl;
@property (strong, nonatomic) NSString *daySelected;
@property (strong, nonatomic) NSString *classroomSelected;

+ (YStudySearchConst *)shareInstance;

@end
