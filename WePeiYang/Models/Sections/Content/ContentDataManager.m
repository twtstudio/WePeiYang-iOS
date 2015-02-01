//
//  ContentDataManager.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/1.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "ContentDataManager.h"
#import "twtAPIs.h"
#import "AFNetworking.h"
#import "JSONKit.h"

@implementation ContentDataManager

+ (void)getIndexDataWithParameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[twtAPIs contentList] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([operation.responseString objectFromJSONString]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

+ (void)getDetailDataWithParameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[twtAPIs contentDetail] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([operation.responseString objectFromJSONString]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

@end
