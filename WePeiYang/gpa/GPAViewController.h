//
//  GPAViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-10.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTrendChartView.h"
#import "GPALoginViewController.h"

@interface GPAViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, SelectTermDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UILabel *noLoginLabel;
@property (strong, nonatomic) IBOutlet UIImageView *noLoginImg;
@property (strong, nonatomic) YTrendChartView *chart;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)openActionSheet:(id)sender;
- (IBAction)backToHomeBtn:(id)sender;

@end
