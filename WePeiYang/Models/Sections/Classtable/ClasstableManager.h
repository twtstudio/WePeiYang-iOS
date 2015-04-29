//
//  ClasstableManager.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/3/20.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "twtAPIs.h"
#import "data.h"
#import "AccountManager.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "wpyCacheManager.h"

@interface ClasstableManager : NSObject

+ (void)getClassDataIfSuccess:(void(^)())success orFailure:(void(^)(NSInteger statusCode, NSString *errStr))failure;
+ (void)getTermStartTimeIfSuccess:(void(^)())success orFailure:(void(^)(NSInteger statusCode, NSString *errStr))failure;

@end
