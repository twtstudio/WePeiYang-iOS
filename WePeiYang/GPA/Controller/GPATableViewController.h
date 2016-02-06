//
//  GPATableViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/8.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JBChartView/JBLineChartView.h>

#define GPA_CACHE @"gpaCache"
#define GPA_USER_NAME_CACHE @"gpaUserNameAndPassword"
#define ALLOW_SPOTLIGHT_KEY @"allowSpotlightIndex"

@interface GPATableViewController : UITableViewController<JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *gpaLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet JBLineChartView *chartView;

- (IBAction)moreActions:(id)sender;

@end
