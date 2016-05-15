//
//  MsgDisplay.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/17.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "MsgDisplay.h"
#import "SVProgressHUD.h"
#import "Chameleon.h"

@implementation MsgDisplay

+ (void)showSuccessMsg:(NSString *)successStr {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD showSuccessWithStatus:successStr];
}

+ (void)showErrorMsg:(NSString *)errorStr {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD showErrorWithStatus:errorStr];
}

+ (void)showLoading {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
}

+ (void)dismiss {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}

@end
