//
//  RecordViewController.h
//  Library
//
//  Created by Qin Yubo on 13-11-5.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableData *response;
@property (strong, nonatomic) IBOutlet UILabel *noLoginLabel;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIImageView *noLoginImg;
@property (strong, nonatomic) IBOutlet UIButton *continueBtn;

- (IBAction)back:(id)sender;
- (IBAction)continueLend:(id)sender;

@end
