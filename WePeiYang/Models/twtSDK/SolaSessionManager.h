//
//  SolaSessionManager.h
//  Project Sola
//
//  Created by Qin Yubo on 15/10/28.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, SessionType) {
    SessionTypeGET = 0,
    SessionTypePOST = 1,
};

@interface SolaSessionManager : NSObject

+ (void)solaSessionWithSessionType:(SessionType)type URL:(NSString *)url token:(NSString *)token parameters:(NSDictionary *)parameters success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
