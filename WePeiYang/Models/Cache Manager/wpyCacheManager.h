//
//  wpyCacheManager.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/3/19.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wpyCacheManager : NSObject

+ (void)saveCacheData:(id)cacheData withKey:(NSString *)keyStr;
+ (void)loadCacheDataWithKey:(NSString *)keyStr andBlock:(void(^)(id cacheData))block;
+ (void)removeCacheDataForKey:(NSString *)keyStr;
+ (BOOL)cacheDataExistsWithKey:(NSString *)keyStr;

+ (void)saveGroupCacheData:(id)cacheData withKey:(NSString *)keyStr;
+ (void)loadGroupCacheDataWithKey:(NSString *)keyStr andBlock:(void(^)(id cacheData))block;
+ (void)removeGroupCacheDataForKey:(NSString *)keyStr;

@end
