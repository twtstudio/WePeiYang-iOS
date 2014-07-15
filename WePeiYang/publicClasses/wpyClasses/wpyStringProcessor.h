//
//  wpyStringProcessor.h
//  WePeiYang
//
//  Created by Qin Yubo on 14-3-25.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wpyStringProcessor : NSObject

{
    void (^finishCallbackBlock)(NSString *);
}

@property (strong) void (^finishCallbackBlock)(NSString *);

+ (void)convertToWebViewByString:(NSString *)contentStr withFinishCallbackBlock:(void(^)(NSString *))block;
+ (void)convertToTextViewByString:(NSString *)contentStr withFinishCallbackBlock:(void(^)(NSString *))block;

@end
