//
//  GPATableViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/8.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBLineChartView.h"

#define GPA_CACHE @"gpaCache"
#define GPA_USER_NAME_CACHE @"gpaUserNameAndPassword"

@interface GPATableViewController : UITableViewController<JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *gpaLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet JBLineChartView *chartView;

- (IBAction)refresh:(id)sender;

@end
