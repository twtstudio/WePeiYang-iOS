//
//  LAFound_AnnounceViewController.h
//  LostAndFound
//
//  Created by 马骁 on 14-4-14.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LAFoundAnnounceForm.h"

@interface LAFound_AnnounceViewController : UIViewController<UIAlertViewDelegate, FXFormControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FXFormController *formController;

@end
