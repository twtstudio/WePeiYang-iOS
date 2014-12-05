//
//  LAFound_DataManager.m
//  WePeiYang
//
//  Created by 马骁 on 14-8-29.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "LAFound_DataManager.h"

static NSString *getItemInfoUrlString = @"http://push-mobile.twtapps.net/lostfound/getList";
static NSString *announceItemInfoUrlString = @"http://push-mobile.twtapps.net/lostfound/new";

@implementation LAFound_DataManager

+ (void)announceItemInfoWithType:(ItemInfoType)type title:(NSString *)title place:(NSString *)place time:(NSString *)time phone:(NSString *)phone name:(NSString *)name content:(NSString *)content success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *parameters = @{@"type": [NSString stringWithFormat:@"%lu", type],
                                 @"title": title,
                                 @"place": place,
                                 @"time": time,
                                 @"phone": phone,
                                 @"name": name,
                                 @"content": content};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:announceItemInfoUrlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[operation valueForKeyPath:@"response.statusCode"] intValue] == 200)
        {
            success(@"发布成功");
        } else {
            success(@"发布失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
   
}

+ (void)getItemInfoWithItemInfoType:(ItemInfoType)type andPage:(NSInteger)page success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *parameters = @{@"type": [NSString stringWithFormat:@"%lu", type],
                                 @"page": [NSString stringWithFormat:@"%ld", (long)page]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:getItemInfoUrlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[operation valueForKeyPath:@"response.statusCode"] intValue] == 200)
        {
            success(responseObject);
        } else {
            success(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}





@end
