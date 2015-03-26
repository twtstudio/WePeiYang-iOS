//
//  LAFound_DataManager.h
//  WePeiYang
//
//  Created by 马骁 on 14-8-29.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"


typedef NS_ENUM(NSUInteger, ItemInfoType) {
    ItemInfoTypeLost,
    ItemInfoTypeFound,
};

@interface LAFound_DataManager : NSObject

+ (void)getItemInfoWithItemInfoType:(ItemInfoType)type andPage:(NSInteger)page success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

+ (void)announceItemInfoWithType:(ItemInfoType)type title:(NSString *)title place:(NSString *)place time:(NSString *)time phone:(NSString *)phone name:(NSString *)name content:(NSString *)content success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;


@end
