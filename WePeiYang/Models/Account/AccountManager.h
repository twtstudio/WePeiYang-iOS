//
//  AccountManager.h
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/25.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TOKEN_SAVE_KEY @"twtToken"
#define ID_SAVE_KEY @"twtId"
#define TJU_BIND_KEY @"bindTju"

@interface AccountManager : NSObject

+ (BOOL)tokenExists;
+ (void)removeToken;
+ (void)getTokenWithTwtUserName:(NSString *)twtuname password:(NSString *)password success:(void(^)())success failure:(void(^)(NSString *errorMsg))failure;
+ (void)refreshTokenSuccess:(void(^)(NSString *newToken))success failure:(void(^)(NSString *errorMsg))failure;
+ (void)tokenIsValid:(void(^)())success failure:(void(^)(NSString *errorMsg))failure;

+ (void)bindTjuAccountWithTjuUserName:(NSString *)tjuuname password:(NSString *)tjupwd success:(void(^)())success failure:(void(^)(NSString *errorMsg))failure;
+ (void)unbindTjuAccountSuccess:(void(^)())success failure:(void(^)(NSString *errorMsg))failure;

@end
