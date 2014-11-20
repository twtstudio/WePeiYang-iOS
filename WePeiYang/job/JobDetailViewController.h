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
@property (retain, nonatomic) NSString *jobTitle;
@property (retain, nonatomic) NSString *jobCorp;
@property (retain, nonatomic) NSString *jobDate;
@property (retain, nonatomic) NSString *jobId;

@end
