//
//  MsgDisplay.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/17.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "MsgDisplay.h"
#import "CRToast.h"
#import "Chameleon.h"

@implementation MsgDisplay

+ (void)showSuccessMsg:(NSString *)successStr {
    dispatch_async(dispatch_get_main_queue(), ^() {
        NSDictionary *options = @{kCRToastNotificationTypeKey: @(CRToastTypeNavigationBar),
                                  kCRToastNotificationPresentationTypeKey: @(CRToastPresentationTypeCover),
                                  kCRToastTextKey: successStr,
                                  kCRToastTextAlignmentKey: @(NSTextAlignmentCenter),
                                  kCRToastTimeIntervalKey: @(1.0),
                                  kCRToastBackgroundColorKey: [UIColor flatMintColor],
                                  kCRToastAnimationInTypeKey: @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationOutTypeKey: @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationInDirectionKey: @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationOutDirectionKey: @(CRToastAnimationDirectionTop),
                                  kCRToastInteractionRespondersKey: @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap automaticallyDismiss:YES block:nil]]};
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
    });
}

+ (void)showErrorMsg:(NSString *)errorStr {
    dispatch_async(dispatch_get_main_queue(), ^(){
        NSDictionary *options = @{kCRToastNotificationTypeKey: @(CRToastTypeNavigationBar),
                                  kCRToastNotificationPresentationTypeKey: @(CRToastPresentationTypeCover),
                                  kCRToastTextKey: errorStr,
                                  kCRToastTextAlignmentKey: @(NSTextAlignmentCenter),
                                  kCRToastTimeIntervalKey: @(1.0),
                                  kCRToastBackgroundColorKey: [UIColor flatWatermelonColorDark],
                                  kCRToastAnimationInTypeKey: @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationOutTypeKey: @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationInDirectionKey: @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationOutDirectionKey: @(CRToastAnimationDirectionTop),
                                  kCRToastInteractionRespondersKey: @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap automaticallyDismiss:YES block:nil]]};
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
    });
}

+ (void)showLoading {
    dispatch_async(dispatch_get_main_queue(), ^(){
        NSDictionary *options = @{kCRToastNotificationTypeKey: @(CRToastTypeStatusBar),
                                  kCRToastNotificationPresentationTypeKey: @(CRToastPresentationTypeCover),
                                  kCRToastTextKey: NSLocalizedString(@"Loading...", nil),
                                  kCRToastTextAlignmentKey: @(NSTextAlignmentCenter),
                                  kCRToastShowActivityIndicatorKey: @YES,
                                  kCRToastActivityIndicatorAlignmentKey: @(CRToastAccessoryViewAlignmentCenter),
                                  kCRToastForceUserInteractionKey: @YES,
                                  kCRToastBackgroundColorKey: [UIColor flatSkyBlueColor],
                                  kCRToastAnimationInTypeKey: @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationOutTypeKey: @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationInDirectionKey: @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationOutDirectionKey: @(CRToastAnimationDirectionTop)};
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
    });
}

+ (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^(){
        [CRToastManager dismissNotification:YES];
    });
}

@end
