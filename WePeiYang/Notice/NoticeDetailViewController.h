//
//  NoticeDetailViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-12.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeDetailViewController : UIViewController<UIActionSheetDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
