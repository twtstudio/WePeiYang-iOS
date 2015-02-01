//
//  GPADataManager.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/1.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "GPADataManager.h"
#import "twtAPIs.h"
#import "JSONKit.h"

@implementation GPADataManager {
    NSDictionary *gpaData;
}

+ (void)getDataWithParameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[twtAPIs GPAInquire] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([operation.responseString objectFromJSONString]);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation.response.statusCode);
    }];
}

+ (void)autoEvaluateWithParameters:(NSDictionary *)parameters success:(void (^)())success failure:(void (^)(NSInteger))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[twtAPIs GPAAutoEvaluate] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation.response.statusCode);
    }];
}

@end
