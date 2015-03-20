//
//  ClasstableManager.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/3/20.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "ClasstableManager.h"

@implementation ClasstableManager

+ (void)getClassDataIfSuccess:(void (^)())success orFailure:(void (^)(NSInteger, NSString *))failure {
    if ([AccountManager isLoggedIn]) {
        if ([AccountManager isTjuBinded]) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *url = [twtAPIs classTable];
            NSDictionary *parameters = @{@"id": [data shareInstance].userId,
                                         @"token": [data shareInstance].userToken,
                                         @"platform": @"ios",
                                         @"version": [data shareInstance].appVersion};
            [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                success();
                [wpyCacheManager saveGroupCacheData:[operation.responseString objectFromJSONString] withKey:@"Classtable"];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(operation.response.statusCode, error.localizedDescription);
            }];
        } else {
            failure(1, @"未绑定");
        }
    } else {
        failure(2, @"未登录");
    }
}

+ (void)getTermStartTimeIfSuccess:(void (^)())success orFailure:(void (^)(NSInteger, NSString *))failure {
    if ([AccountManager isLoggedIn]) {
        if ([AccountManager isTjuBinded]) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *url = [twtAPIs termStartTime];
            NSDictionary *parameters = @{@"platform": @"ios",
                                         @"version": [data shareInstance].appVersion};
            [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                success();
                [wpyCacheManager saveGroupCacheData:[operation.responseString objectFromJSONString] withKey:@"StartTime"];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(operation.response.statusCode, error.localizedDescription);
            }];
        }
    }
}

@end
