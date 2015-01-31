//
//  FeedbackController.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface FeedbackController : UIViewController <FXFormControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FXFormController *formController;

@end
