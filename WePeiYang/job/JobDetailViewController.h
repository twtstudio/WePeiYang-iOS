//
//  JobDetailViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-11.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobDetailViewController : UIViewController<UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (NSString *)filterHTML:(NSString *)html;

@end
