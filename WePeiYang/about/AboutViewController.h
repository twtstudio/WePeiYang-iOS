//
//  AboutViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-18.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backToHome:(id)sender;

@end
