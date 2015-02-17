//
//  MsgDisplay.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/17.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "MsgDisplay.h"
#import "SVProgressHUD.h"

@implementation MsgDisplay

+ (void)showSuccessMsg:(NSString *)successStr {
    dispatch_async(dispatch_get_main_queue(), ^() {
        [SVProgressHUD showSuccessWithStatus:successStr maskType:SVProgressHUDMaskTypeBlack];
    });
}

+ (void)showErrorMsg:(NSString *)errorStr {
    dispatch_async(dispatch_get_main_queue(), ^(){
        [SVProgressHUD showErrorWithStatus:errorStr maskType:SVProgressHUDMaskTypeBlack];
    });
}

+ (void)showLoading {
    dispatch_async(dispatch_get_main_queue(), ^(){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    });
}

+ (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^(){
        [SVProgressHUD dismiss];
    });
}

@end
