//
//  wpyWebConnection.h
//  WePeiYang
//
//  Created by Qin Yubo on 14-3-12.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wpyWebConnection : NSObject<NSURLConnectionDataDelegate>

{
    UIAlertView *waitingAlert;
    NSMutableData *resultData;
    void (^finishCallbackBlock)(NSDictionary *);
}

@property NSMutableData *resultData;
@property (strong) void (^finishCallbackBlock)(NSDictionary *);

+ (void)getDataFromURLStr:(NSString *)urlStr withFinishCallbackBlock:(void (^)(NSDictionary *))block;
+ (void)postDataToURLStr:(NSString *)urlStr withFinishCallbackBlock:(void (^)(NSDictionary *))block;
+ (void)getDataFromURLStr:(NSString *)urlStr andBody:(NSString *)body withFinishCallbackBlock:(void(^)(NSDictionary *))block;

@end
