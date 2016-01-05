//
//  NewsContentViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 15/12/7.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsData.h"

@interface NewsContentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;

@property (strong, nonatomic) NewsData *newsData;

- (IBAction)shareContent:(id)sender;

@end
