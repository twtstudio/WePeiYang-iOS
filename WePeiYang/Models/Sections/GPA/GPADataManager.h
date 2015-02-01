//
//  GPADataManager.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/1.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "data.h"
#import "AFNetworking.h"

@interface GPADataManager : NSObject

+ (void)getDataWithParameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSInteger statusCode))failure;

+ (void)autoEvaluateWithParameters:(NSDictionary *)parameters success:(void(^)())success failure:(void(^)(NSInteger statusCode))failure;

@end
