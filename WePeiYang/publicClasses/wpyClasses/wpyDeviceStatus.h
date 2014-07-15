//
//  wpyDeviceStatus.h
//  WePeiYang
//
//  Created by Qin Yubo on 14-4-3.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wpyDeviceStatus : NSObject

{
    void (^finishCallbackBlock)(NSDictionary *);
}

@property (strong) void (^finishCallbackBlock)(NSDictionary *);

+ (void)getDeviceStatusWithFinishCallbackBlock:(void(^)(NSDictionary *))block;

@end
