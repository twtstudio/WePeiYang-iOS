//
//  ReceivedNotificationViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 14-3-10.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceivedNotificationViewController : UIViewController<UIActionSheetDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)backToFormerView:(id)sender;
- (IBAction)moreBtn:(id)sender;

@end
