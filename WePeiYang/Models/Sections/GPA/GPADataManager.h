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

+ (void)getDataWithParameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSInteger statusCode, NSString *errStr))failure;

+ (void)autoEvaluateWithParameters:(NSDictionary *)parameters success:(void(^)())success failure:(void(^)(NSInteger statusCode, NSString *errStr))failure;

+ (void)processGPAData:(NSDictionary *)gpaDic finishBlock:(void (^)(NSMutableArray *gpaData, float gpa, float score, NSArray *termsInGraph, NSMutableArray *terms, NSMutableArray *everyScoreArr, NSMutableArray *everyGpaArr, NSMutableArray *newAddedSubjects))block;

@end
