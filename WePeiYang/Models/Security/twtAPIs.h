//
//  twtAPIs.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/31.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface twtAPIs : NSObject

+ (NSString *)twtAPINewsList;
+ (NSString *)twtAPINewsDetail;
+ (NSString *)twtAPIStudySearch;
+ (NSString *)twtAPIGPAInquire;
+ (NSString *)twtAPIGPAAutoEvaluate;
+ (NSString *)twtAPILogin;
+ (NSString *)twtAPIBindLib;
+ (NSString *)twtAPIBindTju;
+ (NSString *)twtAPIUnbindLib;
+ (NSString *)twtAPIUnbindTju;
+ (NSString *)twtAPILogout;

@end
