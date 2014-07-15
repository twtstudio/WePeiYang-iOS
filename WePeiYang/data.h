//
//  data.h
//  News
//
//  Created by Qin Yubo on 13-10-13.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface data : NSObject

//for user
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *userToken;

//for News

@property (nonatomic, retain) NSString *newsTitle;
@property (nonatomic, retain) NSString *newsId;
@property (nonatomic, retain) NSString *typeSelected;

//for Library
@property (retain, nonatomic) NSDictionary *recordDic;
@property (retain, nonatomic) NSString *welcomeLabelString;
@property (retain, nonatomic) NSString *libLogin;
@property (retain, nonatomic) NSString *libraryUsername;
@property (retain, nonatomic) NSString *libraryPassword;
@property (retain, nonatomic) NSString *titleSelected;
@property (retain, nonatomic) NSString *authorSelected;
@property (retain, nonatomic) NSString *positionSelected;
@property (retain, nonatomic) NSString *yearSelected;
@property (retain, nonatomic) NSString *leftSelected;

//for GPA
@property (retain, nonatomic) NSString *gpaLoginStatus;
@property (retain, nonatomic) NSArray *every;
@property (retain, nonatomic) NSArray *term;
@property (retain, nonatomic) NSArray *termsInGraph;

//for GPA Calculator
@property (retain, nonatomic) NSArray *gpaDataArray;

//for Jobs
@property (retain, nonatomic) NSString *jobTitle;
@property (retain, nonatomic) NSString *jobCorp;
@property (retain, nonatomic) NSString *jobDate;
@property (retain, nonatomic) NSString *jobId;

//for Hiring
@property (retain, nonatomic) NSString *hiringTitle;
@property (retain, nonatomic) NSString *hiringCorp;
@property (retain, nonatomic) NSString *hiringDate;
@property (retain, nonatomic) NSString *hiringTime;
@property (retain, nonatomic) NSString *hiringPlace;
@property (retain, nonatomic) NSString *hiringId;

//for Notice
@property (retain, nonatomic) NSString *noticeTitle;
@property (retain, nonatomic) NSString *noticeId;

//for Total
@property (retain, nonatomic) NSString *appVersion;
@property (retain, nonatomic) NSString *pushId;
@property (retain, nonatomic) NSString *pushMsg;
@property (retain, nonatomic) NSString *deviceToken;

+ (data *)shareInstance;

@end
