//
//  twtSDK.h
//  Project Sola
//
//  Created by Qin Yubo on 15/10/28.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NewsType) {
    NewsTypeTJU,
    NewsTypeNotic,
    NewsTypeSociety,
    NewsTypeCollege,
    NewsTypeView
};

@interface twtSDK : NSObject

/**
 *  为 twtSDK 注册 AppKey 与 AppSecret
 *
 *  @param appKey    AppKey
 *  @param appSecret AppSecret
 */
+ (void)setAppKey:(NSString *)appKey appSecret:(NSString *)appSecret;

+ (void)getGpaWithToken:(NSString *)token success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure userCanceledCaptcha:(void(^)())userCanceled;

+ (void)getNewsListWithType:(NewsType)type page:(NSUInteger)page success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)getNewsContentWithIndex:(NSString *)index success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)postNewsCommentWithIndex:(NSString *)index content:(NSString *)content success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

// Account Related

+ (void)getTokenWithTwtUserName:(NSString *)twtuname password:(NSString *)twtpasswd success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;
+ (void)refreshTokenWithOldToken:(NSString *)token success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;
+ (void)checkToken:(NSString *)token success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)getClasstableWithToken:(NSString *)token success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)getLostFoundListWithType:(NSInteger)type page:(NSInteger)page success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;
+ (void)getLostFoundDetailWithID:(NSString *)index success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
