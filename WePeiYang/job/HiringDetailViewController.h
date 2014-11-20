//
//  HiringDetailViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 14-5-9.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HiringDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) NSString *hiringTitle;
@property (retain, nonatomic) NSString *hiringCorp;
@property (retain, nonatomic) NSString *hiringDate;
@property (retain, nonatomic) NSString *hiringTime;
@property (retain, nonatomic) NSString *hiringPlace;
@property (retain, nonatomic) NSString *hiringId;

@end
