//
//  NewsTableViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/17.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsTableViewControllerDelegate <NSObject>

- (void)pushContentWithIndex:(NSString *)index;

@end

@interface NewsTableViewController : UITableViewController

@property (nonatomic) NSInteger tag;
@property (assign, nonatomic) id<NewsTableViewControllerDelegate> delegate;

@end
