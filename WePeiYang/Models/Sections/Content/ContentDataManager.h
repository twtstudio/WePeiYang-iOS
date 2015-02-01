//
//  ContentDataManager.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/1.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentDataManager : NSObject

+ (void)getIndexDataWithParameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSString *error))failure;
+ (void)getDetailDataWithParameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *error))failure;

@end
