//
//  LAFound_QueryListViewController.h
//  LostAndFound
//
//  Created by 马骁 on 14-4-16.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LAFound_QueryListViewController;

@protocol LAFound_QueryListViewControllerDelegate <NSObject>

- (void)LAFound_QueryListViewController:(LAFound_QueryListViewController *)qdVC ShowDetailByDataDic:(NSDictionary*)dic;

@end

@interface LAFound_QueryListViewController : UITableViewController

@property id<LAFound_QueryListViewControllerDelegate>delegate;

@end
