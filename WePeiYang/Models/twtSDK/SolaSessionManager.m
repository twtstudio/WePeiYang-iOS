//
//  SolaSessionManager.m
//  Sola
//
//  Created by Qin Yubo on 15/10/28.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#define TWT_ROOT_URL @"http://open.twtstudio.com/api/v1"
#define DEV_RECORD_SESSION_INFO @"DEV_RECORD_SESSION_INFO"

#import "SolaSessionManager.h"
#import "SolaInstance.h"
#import "twtSDK.h"
#import "NSString+Hashes.h"
#import "SolaFoundationKit.h"
#import "WePeiyang-Swift.h"

@implementation SolaSessionManager

+ (void)solaSessionWithSessionType:(SessionType)type URL:(NSString *)url token:(NSString *)token parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", TWT_ROOT_URL, url];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [para setObject:timeStamp forKey:@"t"];
    
    // 字典升序排列
    // obj1 从最后的数组元素开始
    NSArray *keys = [para allKeys];
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2] == NSOrderedDescending;
    }];
    // 字符串连接 & SHA-1
    NSString *sign = @"";
    for (NSString *tmpKey in keys) {
        sign = [sign stringByAppendingString:[NSString stringWithFormat:@"%@%@", tmpKey, para[tmpKey]]];
    }
    sign = [NSString stringWithFormat:@"%@%@%@", [SolaInstance shareInstance].appKey, sign, [SolaInstance shareInstance].appSecret];
    sign = [[sign sha1] uppercaseString];
    
    [para setObject:sign forKey:@"sign"];
    [para setObject:[SolaInstance shareInstance].appKey forKey:@"app_key"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[SolaFoundationKit userAgentString] forHTTPHeaderField:@"User-Agent"];
    if (token != nil && token.length > 0) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer {%@}", token] forHTTPHeaderField:@"Authorization"];
    }

    if (type == SessionTypeGET) {
        [manager GET:fullURL parameters:para progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:DEV_RECORD_SESSION_INFO] == YES) {
                [DevSessionRecorder recordSession:fullURL type:type parameters:para response:responseObject];
            }
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            id responseObject = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingMutableLeaves error:nil];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:DEV_RECORD_SESSION_INFO] == YES) {
                [DevSessionRecorder recordSession:fullURL type:type parameters:para response:responseObject];
            }
            failure(task, error);
        }];
    } else if (type == SessionTypePOST) {
        [manager POST:fullURL parameters:para progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:DEV_RECORD_SESSION_INFO] == YES) {
                [DevSessionRecorder recordSession:fullURL type:type parameters:para response:responseObject];
            }
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            id responseObject = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingMutableLeaves error:nil];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:DEV_RECORD_SESSION_INFO] == YES) {
                [DevSessionRecorder recordSession:fullURL type:type parameters:para response:responseObject];
            }
            failure(task, error);
        }];
    }
}

@end
