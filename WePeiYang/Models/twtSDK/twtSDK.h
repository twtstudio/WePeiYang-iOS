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

/**
 *  获取 GPA 数据并通过 block 回调，需要输入验证码时弹框并递归直到返回 block 或用户取消
 *
 *  @param username 办公网用户名
 *  @param password 办公网密码
 *  @param success  回调 block，包括 NSURLSessionTask 和解析过的 id
 *  @param failure  失败 block
 *  @param userCanceled 用户取消验证框的回调
 */
+ (void)getGpaWithTjuUsername:(NSString *)username password:(NSString *)password success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure userCanceledCaptcha:(void(^)())userCanceled;

+ (void)getNewsListWithType:(NewsType)type page:(NSUInteger)page success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)getNewsContentWithIndex:(NSString *)index success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
