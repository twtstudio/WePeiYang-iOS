//
//  AccountManager.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/5.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    twtLoginTypeNormal,
    twtLoginTypeGPA,
    twtLoginTypeLibrary
} twtLoginType;

@interface AccountManager : NSObject

+ (BOOL)isLoggedIn;
+ (BOOL)isTjuBinded;
+ (BOOL)isLibBinded;

+ (void)loginWithParameters:(NSDictionary *)parameters andType:(twtLoginType)type Success:(void(^)())success Failure:(void(^)(NSInteger statusCode, NSString *errorStr))failure;
+ (void)logoutWithParameters:(NSDictionary *)parameters withBlock:(void(^)())block;

+ (void)bindTjuWithParameters:(NSDictionary *)parameters success:(void(^)())success failure:(void(^)(NSInteger statusCode, NSString *errorStr))failure;
+ (void)bindLibWithParameters:(NSDictionary *)parameters success:(void(^)())success failure:(void(^)(NSInteger statusCode, NSString *errorStr))failure;

+ (void)unBindTjuWithParameters:(NSDictionary *)parameters success:(void(^)())success failure:(void(^)())failure;
+ (void)unBindLibWithParameters:(NSDictionary *)parameters success:(void(^)())success failure:(void(^)())failure;

@end
