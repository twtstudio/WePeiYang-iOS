//
//  MsgDisplay.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/17.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgDisplay : NSObject

+ (void)showSuccessMsg:(NSString *)successStr;
+ (void)showErrorMsg:(NSString *)errorStr;
+ (void)showLoading;
+ (void)dismiss;

@end
