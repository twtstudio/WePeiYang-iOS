//
//  LAFound_CollectionViewController.h
//  LostAndFound
//
//  Created by 马骁 on 14-4-16.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LAFound_CollectionViewController;

@protocol LAFound_CollectionViewControllerDelegate <NSObject>

- (void)LAFound_CollectionViewController:(LAFound_CollectionViewController *)cVC ShowDetailByDataDic:(NSDictionary *)dic;

@end

@interface LAFound_CollectionViewController : UITableViewController

@property (weak, nonatomic) id<LAFound_CollectionViewControllerDelegate>delegete;

@end
