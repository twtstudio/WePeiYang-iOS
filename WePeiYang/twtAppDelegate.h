//
//  twtAppDelegate.h
//  WePeiYang
//
//  Created by Qin Yubo on 13-11-28.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "RESideMenu.h"

@interface twtAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
