//
//  GPACalculatorViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 14-1-28.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "data.h"
#import "WePeiYang-Swift.h"

typedef enum {
    gpaCalcRuleJasso,
    gpaCalcRuleStandard,
    gpaCalcRuleFourPt,
    gpaCalcRuleImprovedFourPt,
    gpaCalcRuleCanada,
} gpaCalcRule;

@interface GPACalculatorViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *gpaData;

@end
