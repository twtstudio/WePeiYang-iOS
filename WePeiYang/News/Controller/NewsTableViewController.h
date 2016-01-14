//
//  NewsTableViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/17.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PUSH_NOTIFICATION @"pushNotification"

//@protocol NewsTableViewControllerDelegate <NSObject>
//
//- (void)pushContentWithIndex:(NSString *)index;
//
//@end

@interface NewsTableViewController : UITableViewController

@property (nonatomic) NSInteger type;
//@property (assign, nonatomic) id<NewsTableViewControllerDelegate> delegate;

@end
