//
//  NoticeViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-12.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NoticeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
