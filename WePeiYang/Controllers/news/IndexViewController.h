//
//  IndexViewController.h
//  News
//
//  Created by Qin Yubo on 13-10-11.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/*
@protocol PushViewControllerDelegate <NSObject>

- (void)push;

@end
 */

@interface IndexViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, assign) id<PushViewControllerDelegate> delegate;

@end
