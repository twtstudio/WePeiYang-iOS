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

@property (nonatomic, retain) NSString *typeSelected;

//for Library
@property (retain, nonatomic) NSDictionary *recordDic;
@property (retain, nonatomic) NSString *welcomeLabelString;
@property (retain, nonatomic) NSString *libLogin;
@property (retain, nonatomic) NSString *libraryUsername;
@property (retain, nonatomic) NSString *libraryPassword;

//for GPA
@property (retain, nonatomic) NSString *gpaLoginStatus;

//for Total
@property (retain, nonatomic) NSString *appVersion;
//@property (retain, nonatomic) NSString *pushId;
//@property (retain, nonatomic) NSString *pushMsg;
//@property (retain, nonatomic) NSString *deviceToken;
@property (nonatomic) CGFloat deviceWidth;

+ (data *)shareInstance;

@end
